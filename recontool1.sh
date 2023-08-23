#!/bin/bash

Domain=$1

#RED="/033[1;31m"
#RESET="/033[om"

info_path=$Domain/info
subdomain_path=$Domain/subdomain
screenshort_path=$Domain/screenshort

if [ ! -d "$Domain" ] ; then
    mkdir $Domain
fi

if [ ! -d "$info_path" ] ; then
    mkdir $info_path
fi

if [ ! -d "$subdomain_path" ] ; then
    mkdir $subdomain_path
fi

if [ ! -d "$screenshort_path" ] ; then
    mkdir $screenshort_path
fi

echo -e " [+] info of ${Domain} "
whois $1 > $info_path/whois.txt

echo -e " [+]  Launching subdomain finder for ${Domain} "
subfinder -d  $Domain >> $subdomain_path/subdomain.txt


echo -e " [+]  Launching assertfinder  for ${Domain} "
assetfinder $Domain | grep $Domain > $subdomain_path/subdomain.txt


#echo -e " [+]  Launching assertfinder for ${Domain} "
#amass enum -d  $Domain >> $subdomain_path/subdomain.txt


echo -e " [+]  chekking what is alive for ${Domain} "
cat $subdomain_path/subdomain.txt | grep $Domain | sort -u | httprobe -prefer-https | grep https | sed 's/https\?:\/\///'| tee -a $subdomain_path/alive.txt

echo -e " [+]  finding sccreeenshort for alive in ${Domain} "
gowitness file -f $subdomain_path/alive.txt -P $screenshort_path/  --no-http




