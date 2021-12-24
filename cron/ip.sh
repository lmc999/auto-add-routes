#!/bin/bash 

cidr_32=255.255.255.255
cidr_31=255.255.255.254
cidr_30=255.255.255.252
cidr_29=255.255.255.248
cidr_28=255.255.255.240
cidr_27=255.255.255.224
cidr_26=255.255.255.192
cidr_25=255.255.255.128
cidr_24=255.255.255.0
cidr_23=255.255.254.0
cidr_22=255.255.252.0
cidr_21=255.255.248.0
cidr_20=255.255.240.0
cidr_19=255.255.224.0
cidr_18=255.255.192.0
cidr_17=255.255.128.0
cidr_16=255.255.0.0
cidr_15=255.254.0.0
cidr_14=255.252.0.0
cidr_13=255.248.0.0
cidr_12=255.240.0.0
cidr_11=255.224.0.0
cidr_10=255.192.0.0
cidr_9=255.128.0.0
cidr_8=255.0.0.0
cidr_7=254.0.0.0
cidr_6=252.0.0.0
cidr_5=248.0.0.0
cidr_4=240.0.0.0
cidr_3=224.0.0.0
cidr_2=192.0.0.0
cidr_1=128.0.0.0

curl -o ./china_ip_list.txt "https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt"

function cnip(){
	result=$(md5sum ./china_ip_list.txt)
	md5_1=$(echo $result | awk 'NR==1' | awk '{print $1}')
	md5_2=$(echo $result | awk 'NR==2' | awk '{print $1}')
	if [[ "$md5_1" != "$md5_2" ]];then
		cp -f ./china_ip_list.txt ./wireguard/ip_network_primary_sample
		cp -f ./china_ip_list.txt ./openvpn/ip_network_primary_sample
	fi
}

function gfwdomain(){
	curl https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt | base64 -d | sort -u | sed '/^$\|@@/d'| sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' | sed '/\*/d; /apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /qq\.com/d' | sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' | grep '^[0-9a-zA-Z\.-]\+$' | grep '\.' | sed 's#^\.\+##' | sort -u > /tmp/temp_gfwlist.txt
    curl https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf | sed 's/ipset=\/\.//g; s/\/gfwlist//g; /^server/d' > /tmp/temp_koolshare.txt
    cat /tmp/temp_gfwlist.txt /tmp/temp_koolshare.txt | sort -u > ./wireguard/domain_alternative_sample
	cp ./wireguard/domain_alternative_sample ./openvpn/domain_alternative_sample
}
	
rm ./add.txt ./del.txt

function generate(){
	while read -r line || [[ -n $line ]];do
		IP=$(echo $line | cut -d "/" -f1)
		CIDR=$(echo $line | cut -d "/" -f2)
		eval NETMASK=\$cidr_${CIDR}
		echo "add $IP mask $NETMASK default METRIC default IF default" >> ./add.txt
		echo "delete $IP mask $NETMASK default METRIC default IF default" >> ./del.txt
	done < ./china_ip_list.txt
	rm ./china_ip_list.txt
	cp -f ./add.txt ./wireguard/add.txt && cp -f ./add.txt ./openvpn/add.txt
	cp -f ./del.txt ./wireguard/del.txt && cp -f ./del.txt ./openvpn/del.txt
}

function packup(){
	rm -rf ./zip/*
	zip -r -D ./zip/wireguard.zip ./wireguard/*
	zip -r -D ./zip/openvpn.zip ./openvpn/*
}


cnip
gfwdomain
generate
packup
