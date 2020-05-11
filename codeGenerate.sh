#!/bin/bash

if brew ls --versions gnu-sed gawk >/dev/null; then
	echo "gsed and gawk has been installed"
else
	brew install gnu-sed gawk
fi

psp="truemoney"
pspUpper="TRUEMONEY"
pspUpperPre="TrueMoney"
pspShortCut="tru"
pspShortCutUpper="TRU"
pspSandboxUrl="https://api.sandbox.truemoney.com"
pspProductionUrl="https://api.proudction.truemoney.com"

dist=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/channel/"$psp
testingConfigFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/config/gl/config_testing.toml"
sandboxConfigFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/config/grablink/config_staging.toml"
productionConfigFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/config/grablink/config_product.toml"
configGoFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/goconf/config.go"
brandGoFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/model/enum/glCard/brand.go"
fundingGoFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/model/enum/glCard/fundingType.go"
adapterGoFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/service/adapter/adapter.go"
adapterImplGoFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/service/adapter/adapterImpl.go"
respcodeGoFile=$GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/dao/mongo/scanpayRespCode.go"

function modifiConfigFile() {
	pspConfigUrl=$1
	configFile=$2

	echo "###motify "$configFile
	pspConfig="["$pspUpperPre"]\n"$pspUpperPre"URL = \""$pspConfigUrl"\"\n\n"

	while read line; do
		echo $line | grep -q "\[Checkout\]"
		[ $? -eq 0 ] && echo -en $pspConfig >>$configFile".backup"
		echo $line >>$configFile".backup"
	done <$configFile
	mv $configFile".backup" $configFile
}

function modifiConfigGo() {
	echo "###motify "$configGoFile
	goConfig=$pspUpperPre" struct {\n"$pspUpperPre"URL string\n}\n\n"

	while read line; do
		echo $line | grep -q "Checkout\ struct\ {"
		[ $? -eq 0 ] && echo -en $goConfig >>$configGoFile".backup"
		echo $line >>$configGoFile".backup"
	done <$configGoFile
	mv $configGoFile".backup" $configGoFile
}

function modifiBrandGo() {
	echo "###motify "$brandGoFile
	goBrand="case key.PspCode"$pspShortCutUpper":\n return adyenScheme(pspCardScheme)\n"

	while read line; do
		echo $line | grep -q "PspCodeCKO"
		[ $? -eq 0 ] && echo -en $goBrand >>$brandGoFile".backup"
		echo $line >>$brandGoFile".backup"
	done <$brandGoFile
	mv $brandGoFile".backup" $brandGoFile
}

function modifiFundingGo() {
	echo "###motify "$fundingGoFile
	goFunding="case key.PspCode"$pspShortCutUpper":\n return ckoCardFundingType(pspCardFundingType)\n"

	while read line; do
		echo $line | grep -q "PspCodeCKO"
		[ $? -eq 0 ] && echo -en $goFunding >>$fundingGoFile".backup"
		echo $line >>$fundingGoFile".backup"
	done <$fundingGoFile
	mv $fundingGoFile".backup" $fundingGoFile
}

function modifiAdapterGo() {
	echo "###motify "$adapterGoFile
	goAdapter="case key.PspCode"$pspShortCutUpper":\n adapter = New"$pspUpperPre"Cil()\n"

	while read line; do
		echo $line | grep -q "PspCodeCKO"
		[ $? -eq 0 ] && echo -en $goAdapter >>$adapterGoFile".backup"
		echo $line >>$adapterGoFile".backup"
	done <$adapterGoFile
	mv $adapterGoFile".backup" $adapterGoFile
}

function modifiAdapterImplGo() {
	echo "###motify "$adapterImplGoFile
	goAdapterImpl="func New"$pspUpperPre"Cil() *cil {\n return &cil{\nchannel: "$psp"Impl.DefChannel"$pspShortCutUpper",\n}\n}\n\n"

	while read line; do
		echo $line | grep -q "NewCheckoutCil"
		[ $? -eq 0 ] && echo -en $goAdapterImpl >>$adapterImplGoFile".backup"
		echo $line >>$adapterImplGoFile".backup"
	done <$adapterImplGoFile
	mv $adapterImplGoFile".backup" $adapterImplGoFile
}

function modifiRespcodeGo() {
	echo "###motify "$respcodeGoFile
	goRespcode="func (c *isoRespCodeCollection) GetBy"$pspUpperPre"(code string) model.ISORespCode {\n return c.GetByPspCode("$pspUpper", code)\n}\n\n"

	while read line; do
		echo $line | grep -q "GetByCheckout("
		[ $? -eq 0 ] && echo -en $goRespcode >>$respcodeGoFile".backup"
		echo $line >>$respcodeGoFile".backup"
	done <$respcodeGoFile
	mv $respcodeGoFile".backup" $respcodeGoFile

	goRespcode=$pspUpper"=\""$psp"\"\n"

	while read line; do
		echo $line | grep -q "checkout"
		[ $? -eq 0 ] && echo -en $goRespcode >>$respcodeGoFile".backup"
		echo $line >>$respcodeGoFile".backup"
	done <$respcodeGoFile
	mv $respcodeGoFile".backup" $respcodeGoFile
}

echo "###clearing $dist folder"
rm -rf $dist

echo "###coping dist folder"
cp -r $GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/channel/checkout" $dist
mv $dist"/checkoutImpl" $dist"/"$psp"Impl"

echo "###motify $dist"
for i in $(find $dist -type f); do
	echo $i
	gsed -i "s/checkout/$psp/g" $i
	gsed -i "s/CHECKOUT/$pspUpper/g" $i
	gsed -i "s/Checkout/$pspUpperPre/g" $i
	gsed -i "s/cko/$pspShortCut/g" $i
	gsed -i "s/CKO/$pspShortCutUpper/g" $i
done

modifiConfigFile $pspSandboxUrl $testingConfigFile
modifiConfigFile $pspSandboxUrl $sandboxConfigFile
modifiConfigFile $pspProductionUrl $productionConfigFile

modifiConfigGo

echo "###motify stats.go"
pspStats="Statistics"$pspUpperPre"Key    = \""$pspUpperPre"Stats\""
gsed -i "/Checkout/a $pspStats" $GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/common/key/stats.go"

echo "###motify chanCode.go"
pspChanCode="PspCode"$pspShortCutUpper"    = \""$pspUpperPre"\""
gsed -i "/Checkout/a $pspChanCode" $GOPATH"/src/bitbucket.org/grabpay/grablink-online/src/common/key/chanCode.go"

modifiBrandGo
modifiFundingGo
modifiAdapterGo
modifiAdapterImplGo
modifiRespcodeGo
