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
| DOMAIN | Domain name par for your certificate |

(*1) You can obtain user/api key in the following way:
1. Go to infrastructure menu in IBM Cloud.
1. Navigate Account => Users => User List
1. Click on 'Generate' at API KEY column (If you see 'Show', you already have generated your API key)
1. Once generated, click on your email address column
1. Navigate to "API Access Information".
1. Use 'API Username' for SL_USER
1. Use 'Authentication Key' for SL_API_KEY

## Creating certification
