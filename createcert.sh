#!/bin/sh
certbot --version

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "It may take long time (up to a few hours). Please be patient!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

rm -f /etc/letsencrypt/certcreated
certbot $* --manual \
        -m "$EMAIL" \
        --agree-tos \
        -n \
        --manual-public-ip-logging-ok \
        --preferred-challenges dns \
        --manual-auth-hook $(dirname $0)/editdns.sh \
        -d "$HOST_NAME.$DOMAIN" \
        certonly
