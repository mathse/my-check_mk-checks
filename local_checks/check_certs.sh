#!/bin/bash
threshold=1209600 # warn if Certificate will expire within 1209600 seconds -> 14 days
now=$(date +%s)

function check_cert () {
    if [ -f $1 ]
    then
        expire=$(date -d "$(openssl x509 -in $1 -enddate -noout | cut -f2 -d'=')" +%s)
        cn=$(openssl x509 -in $1 -subject -noout | sed -n '/^subject/s/^.*CN=//p')
        lh=$(hostname | tr '[:upper:]' '[:lower:]')
        if [ "$cn" == "$lh/emailAddress=root@$lh" ]
        then
            echo "0 certs_$1 - Certificate for $cn is self signed and will be ignored"
        elif [ $now -ge $expire ]
        then
            echo "2 certs_$1 - Certificate for $cn expired"
        elif [ $(expr $now + $threshold) -ge $expire ]
        then
            h=$(expr $(expr $expire - $now) / 3600)
            echo "1 certs_$1 - Certificate for $cn will expire in $h hours"
        else
            echo "0 certs_$1 - Certificate for $cn ok"
        fi
    fi
}

for userdefinedcerts in $(cat /etc/check_mk/certcheck.d/* 2> /dev/null)
do
    check_cert $userdefinedcerts
done

for apachecerts in $(egrep -h ".(pem|crt)" /etc/apache2/sites-enabled/* 2> /dev/null | awk '{ print $2 }' | sort -u)
do
    check_cert $apachecerts
done

for apachecerts in $(egrep -h ".(pem|crt)" /etc/httpd/conf.d/* 2> /dev/null | awk '{ print $2 }' | sort -u)
do
    check_cert $apachecerts
done

for nginxcerts in $(egrep -h ".(pem|crt)" /etc/nginx/conf.d/* 2> /dev/null | awk '{ print $2 }'  | sed 's/;$//g' | sort -u)
do
    check_cert $nginxcerts
done
