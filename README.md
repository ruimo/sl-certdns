# sl-certdns
Create or renew SSL certificate with Lets Encrypt in IBM Cloud (SoftLayer) environment. Since it uses DNS-01 authentication, you do not need to execute this tool on your web server.

## Prerequisite
Install Docker.

## Environment variable

| Name | Description |
-|-
| SL_USER | User name of SoftLayer (*1) |
| SL_API_KEY | API key of SoftLayer (*1) |
| EMAIL | Admin email for Lets Encrypt (-m parameter for certbot) |
| HOST_NAME | Host name part for your certificate |
| DOMAIN | Domain name part for your certificate |

(*1) You can obtain user/api key in the following way:
1. Go to IBM Cloud web site.
1. Navigate Manage => Access(IAM)
1. Click on Users located left side.
1. Select 'My classic infrastructure users' for your view.
1. Click on your account.
1. Click on 'Create an IBM Cloud API key' to obtain API key (If you have created it before, just click 'Detail' from the right most menu).
1. Use 'API User Name' for SL_USER
1. Use the API key created above for SL_API_KEY

## Creating certificate

Invoke createcert.sh

Example:

    $ docker run -v /etc/letsencrypt:/etc/letsencrypt -e SL_USER='YOUR SOFTLAYER USER' -e SL_API_KEY='YOUR SOFTLAYER API KEY' -e EMAIL='YOUR MAIL ADDRESS' -e HOST_NAME='www' -e DOMAIN='yourdomain.com' --rm ruimo/sl-certdns createcert.sh --staging

This creates SSL certificate for site 'www.yourdmain.com'. Your SSL certificate will be stored in /etc/letsencrypt. You can specify arguments to createcert.sh. They will be simply passed to certbot command. Since '--staging' is specified in this case, certbot will create certificate for staging.

## Wildcard certificate

You can create wildcard certification. Specify '*' for hostname and argument --server https://acme-v02.api.letsencrypt.org/directory.

Example:

    $ docker run -v /tmp/letsencrypt:/etc/letsencrypt -e SL_USER='YOUR SOFTLAYER USER' -e SL_API_KEY='YOUR SOFTLAYER API KEY' -e EMAIL='YOUR MAIL ADDRESS' -e HOST_NAME='*' -e DOMAIN='yourdomain.com' --rm ruimo/sl-certdns createcert.sh --server https://acme-v02.api.letsencrypt.org/directory --staging

This create SSL certificate for site '*.yourdomain.com'. Your SSL certificate will be stored in /etc/letsencrypt. As same as before, '--staging' is specified to let certbot create certificate for staging.

## Renewing certificate

Invoke renewcert.sh

Example:

    $ docker run -v /tmp/letsencrypt:/etc/letsencrypt -e SL_USER='YOUR SOFTLAYER USER' -e SL_API_KEY='YOUR SOFTLAYER API KEY' -e EMAIL='YOUR MAIL ADDRESS' --rm ruimo/sl-certdns renewcert.sh --staging --renew-by-default

Example(Wildcard):

    $ docker run -v /tmp/sl-certdns:/var/log/sl-certdns -v /etc/letsencrypt:/etc/letsencrypt -e SL_USER='YOUR SOFTLAYER USER' -e SL_API_KEY='YOUR SOFTLAYER API KEY' -e EMAIL='YOUR MAIL ADDRESS' -e HOST_NAME='*' -e DOMAIN='YOUR DOMAIN/SUB DOMAIN' --rm ruimo/sl-certdns renewcert.sh --server https://acme-v02.api.letsencrypt.org/directory --staging --renew-by-default

This renews all certificates under /etc/letsencrypt. You can specify arguments to renewcert.sh. They will be simply passed to certbot command. Since '--staging' is specified in this case, certbot will create certificate for staging. The '--renew-by-default' 
force certbot to renew certificate always.

Once certbot renewed the certificate, it creates zero length flag file /etc/letsencrypt/certcreated. So you can check this file afterward to determine if you need to update existing certificates (such as reloading web servers).

## Logging

If you encounter any problems, try take a log by specifying -v /tmp/sl-certdns:/var/log/sl-certdns. Log will be stored in /tmp/sl-certdns in this case.
