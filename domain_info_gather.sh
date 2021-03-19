#!/bin/bash

while true
	do
	echo "Enter the domain(s) to lookup: "

	read -r domains

	[[ $domains == "exit" ]] && exit 0

	for domain in $domains
		do
		rx='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
		
		if [[ $domain =~ ^$rx\.$rx\.$rx\.$rx$ ]]; then
			echo "whois ${domain}"
			whois "$domain" | awk '/NetRange: /,/OrgTechRef: /'
		else
			echo "whois ${domain}"
			whois "$domain" | grep -e 'Domain Name:' -e 'Name Server:' -e 'Registrant ' -e 'Admin ' -e 'Tech '
			printf "\ndig %s\n", "${domain}"
			dig "$domain" | awk '/ANSWER SECTION:/,/Query time: /' | sed '$d' | sed '1d'
		fi
		echo "nslookup ${domain}"
		nslookup "$domain"
		done

done