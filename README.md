# ssl-certcheck
Bash script to check expiration date on SSL certificates.  

Emails user(s) to alert of expiring certificates. 

Slack notification to alert of expiring certificates.

## Requirements
Should work with any Linux distro with standard tools installed (openssl, curl, grep, etc...).  

Requires a MTA (such as Exim4 or Postfix) for email notification. 

Requires valid slack webhook url for slack notification.

Tested on Ubuntu 18.04.  
Create a file in /etc/haproxy called certs.list, and list the locations of all your certificates (example below).

## Usage
Example of certs.list file is below.
```
/etc/haproxy/certificates/demomfi.client.fullchain.crt
/etc/haproxy/certificates/demomfi_server_ca.crt
/etc/haproxy/certificates/demowallet.client.fullchain.crt
/etc/haproxy/certificates/demowallet_server_ca.crt
```

Example of email is below.
```
Subject:
Certificates expiring in 30 days or less on MMD-PreProd-QA

Body:
issuer=CN = demomfi.preprodqak3s.qa.preprod.myanmarpay-pre.io will expire on Jan 17 15:39:15 2022 GMT
issuer=CN = demowallet.preprodqak3s.qa.preprod.myanmarpay-pre.io will expire on Jan 17 15:39:16 2022 GMT

```

Example of slack is below.
```
Slack channel:-

Certificates expiring in 07 days or less on MMD-PreProd-QA
issuer=CN = demomfi.preprodqak3s.qa.preprod.myanmarpay-pre.io will expire on Jan 17 15:39:15 2022 GMT
issuer=CN = demowallet.preprodqak3s.qa.preprod.myanmarpay-pre.io will expire on Jan 17 15:39:16 2022 GMT
```

You can run the script out of root's crontab.
