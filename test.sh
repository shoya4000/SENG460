#!/bin/bash

domain="com"
domain="${domain/[^@]*@/}"
echo $domain

result=$(echo $domain | grep -P '(?=^.{1,254}$)(^(?>(?!\d+\.)[a-zA-Z0-9_\-]{1,63}\.?)+(?:[a-zA-Z]{2,})$)')

echo "$result"

domainrx='?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)'
if [[ -z "$result" ]]; then
	echo "wut"
else
	echo "ding"
fi