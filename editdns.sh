#!/bin/sh
mkdir -p /var/log/sl-certdns
echo Starting editdns.sh >> /var/log/sl-certdns/sl-certdns.log
echo Environment variable: >> /var/log/sl-certdns/sl-certdns.log
printenv >> /var/log/sl-certdns/sl-certdns.log
if [ "$HOST_NAME" != '*' ]; then
    if [ -n $CERTBOT_DOMAIN ]; then
        HOST_NAME=$(echo $CERTBOT_DOMAIN | tr '.' '\n' | head -n 1)
        DOMAIN=$(echo $CERTBOT_DOMAIN | cut -d '.' -f 2-)
        echo HOST_NAME changed: $HOST_NAME >> /var/log/sl-certdns/sl-certdns.log
        echo DOMAIN changed: $DOMAIN >> /var/log/sl-certdns/sl-certdns.log
    fi
fi

echo Executing python $(dirname $0)/editdns.py $SL_USER $SL_API_KEY $DOMAIN "$HOST_NAME" $CERTBOT_VALIDATION >> /var/log/sl-certdns/sl-certdns.log
python $(dirname $0)/editdns.py $SL_USER $SL_API_KEY $DOMAIN "$HOST_NAME" $CERTBOT_VALIDATION >> /var/log/sl-certdns/sl-certdns.log

echo CREATED TOKEN: $CERTBOT_VALIDATION >> /var/log/sl-certdns/sl-certdns.log

# Wait for TXT record is reflected.
count=0
while :
do
    echo "executing: nslookup -q=txt _acme-challenge.$DOMAIN | grep '_acme-challenge' | sed -r 's/.*text = \"(.*)\"/\1/'" >> /var/log/sl-certdns/sl-certdns.log
    TOKEN=$(nslookup -q=txt _acme-challenge.$DOMAIN | grep "_acme-challenge" | sed -r 's/.*text = \"(.*)\"/\1/')
    echo TOKEN ON DNS: "$TOKEN" >> /var/log/sl-certdns/sl-certdns.log

    test "$TOKEN" = $CERTBOT_VALIDATION
    if [ $? -eq 0 ]; then
        echo Token matched. >> /var/log/sl-certdns/sl-certdns.log
        touch /etc/letsencrypt/certcreated
        echo Now wait 1 minute for sure since Lets encrypt side may still get old token... >> /var/log/sl-certdns/sl-certdns.log
        sleep 60
        break
    else
        echo Token does not match. >> /var/log/sl-certdns/sl-certdns.log
    fi

    count=$(expr $count + 1)
    if [ $count -gt 720 ]; then # timeout in 120min
        echo Token does not match for 120 minutes. Timeout. >> /var/log/sl-certdns/sl-certdns.log
        exit 1
    fi

    sleep 10
done
