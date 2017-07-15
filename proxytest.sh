#!/bin/bash
# This program gets ip from ifconfig.me with and without proxychains, checks lenght and compares addresses if valid.
# Dep: proxychains4, wget
# TODO: Add more sources, Add support for curl, Add support for older versions of proxychains4

ip=$(wget -qO - http://ifconfig.me -o ip.log | grep '"ip_address"' | sed 's/[^0-9.]//g')
proxy_ip=$(proxychains4 -q wget -qO - http://ifconfig.me -o proxy.log | grep '"ip_address"' | sed 's/[^0-9.]//g')

wc_ip=$(echo "$ip" | wc -c - | sed 's/[^0-9]//g')
wc_proxy=$(echo "$proxy_ip" | wc -c - | sed 's/[^0-9]//g')

if [ $wc_ip -ge 8 ] && [ $wc_ip -lt 29 ]; then
	if [ $wc_proxy -ge 8 ] && [ $wc_proxy -lt 29 ]; then	
		if [ "$ip" != "$proxy_ip" ]; then
			echo "Proxy: active
			Proxy: $proxy_ip
			True:  $ip"
		else 
			echo "Proxy: inactive
			Proxy: $proxy_ip
			True:  $ip"
		fi
	else 
		echo "Error
		Proxy: $proxy_ip WC: $wc_proxy
		True: $ip WC: $wc_ip"
	fi
else 
	echo "Error
	Proxy: $proxy_ip WC: $wc_proxy
	True: $ip WC: $wc_ip"
fi
exit