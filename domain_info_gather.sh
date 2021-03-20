#!/bin/bash

while true
do
    echo "Enter the domain(s) to lookup: "
    
    read -r domains
    #allow user to exit input loop
    [[ $domains == "exit" ]] && exit 0
    
    for domain in $domains
    do
        #remove user from email addresses if present
        cleandomain="${domain/[^@]*@/}"
        #regex pattern for a valid ip
        iprx='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'
        #regex pattern for a valid fqdn
        domaincheck=$(echo "$domain" | grep -P '(?=^.{1,254}$)(^(?>(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)')
        #if ip address, run whois and nslookup
        if [[ $domain =~ ^$iprx\.$iprx\.$iprx\.$iprx$ ]]; then
            echo "whois ${domain}"
            whois "$cleandomain" | awk '/NetRange: /,/OrgTechRef: /' > "whois_${domain}.output"
            echo "nslookup ${domain}"
            nslookup "$cleandomain" > "nslookup_${domain}.output"
            #if valid domain, run whois, dig, and nslookup
        elif [[ -n "$domaincheck" ]]; then
            echo "whois ${domain}"
            whois "$cleandomain" | grep -e 'Domain Name:' -e 'Name Server:;' -e 'Registrant ' -e 'Admin ' -e 'Tech ' > "whois_${domain}.output"
            printf "\ndig %s\n", "${domain}"
            dig "$cleandomain" | awk '/ANSWER SECTION:/,/Query time: /' | sed '$d' | sed '1d' > "dig_${domain}.output"
            echo "nslookup ${domain}"
            nslookup "$cleandomain" > "nslookup_${domain}.output"
        else
            echo "Invalid input"
        fi
    done
done