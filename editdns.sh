#!/bin/sh
python $(dirname $0)/editdns.py $SL_USER $SL_API_KEY $DOMAIN $HOST_NAME $CERTBOT_VALIDATION

# Wait for TXT record is reflected.
count=0
while :
do
    TOKEN=$(nslookup -q=txt _acme-challenge.ssltest.functionalcapture.com | grep "_acme-challenge" | sed -r 's/.*text = \"(.*)\"/\1/')
    test $TOKEN = $CERTBOT_VALIDATION
    if [ $? -eq 0 ]; then
        break
    fi

    count=$(expr $count + 1)
    if [ $count -gt 720 ]; then # timeout in 120min
        exit 1
    fi

    sleep 10
done
