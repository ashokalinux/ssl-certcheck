#!/bin/bash

#Set variables for time, measured in seconds
seconds_1h=3600
seconds_1d=$(($seconds_1h * 24))   #temp_01d
seconds_1w=$(($seconds_1d * 7))    #temp_07d
seconds_30d=$(($seconds_1d * 30))  #temp_30d
seconds_1y=$(($seconds_1d * 365))  #temp_1y

#Other variables, change as needed
CERT_FILE=/etc/haproxy/certs.list
#RECIPIENT="ashok.shelke@modusbox.com shelkeashok9@gmail.com"
#HOSTNAME=`hostname`
HOSTNAME=MMD-PreProd-QA
SLACK_URL=https://hooks.slack.com/services/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

#check for certs expiring in 01 day or less, get their names and expiration dates
while read CERTS; do
  cert_name=`openssl x509 -issuer -noout -in $CERTS | sed 's/^issuer.*CN=\([a-zA-Z0-9\.\-\*]*\).*$/\1/'`
  cert_date=`openssl x509 -enddate -noout -in $CERTS | sed 's/.*=//'`
  if openssl x509 -checkend $seconds_1d -noout -in $CERTS
  then
    :
  else
    temp_01d="$temp_01d$cert_name will expire on $cert_date\n"
  fi
done < $CERT_FILE

echo -e $temp_01d

#check for certs expiring in 07 days or less, get their names and expiration dates
while read CERTS; do
  cert_name=`openssl x509 -issuer -noout -in $CERTS | sed 's/^issuer.*CN=\([a-zA-Z0-9\.\-\*]*\).*$/\1/'`
  cert_date=`openssl x509 -enddate -noout -in $CERTS | sed 's/.*=//'`
  if openssl x509 -checkend $seconds_1d -noout -in $CERTS
  then
    :
  else
    temp_07d="$temp_07d$cert_name will expire on $cert_date\n"
  fi
done < $CERT_FILE

echo -e $temp_07d


#check for certs expiring in 1 year or less, get their names and expiration dates
#this is commented out because 1 year is too long, mainly used for testing
#while read CERTS; do
#  cert_name=`openssl x509 -issuer -noout -in $CERTS | sed 's/^issuer.*CN=\([a-zA-Z0-9\.\-\*]*\).*$/\1/'`
#  cert_date=`openssl x509 -enddate -noout -in $CERTS | sed 's/.*=//'`
#  if openssl x509 -checkend $seconds_1y -noout -in $CERTS
#  then
#    :
#  else
#    temp_1y="$temp_1y$cert_name will expire on $cert_date\n"
#  fi
#done < $CERT_FILE

#check for certs expiring in 30 days or less, get their names and expiration dates
#while read CERTS; do
#  cert_name=`openssl x509 -issuer -noout -in $CERTS | sed 's/^issuer.*CN=\([a-zA-Z0-9\.\-\*]*\).*$/\1/'`
#  cert_date=`openssl x509 -enddate -noout -in $CERTS | sed 's/.*=//'`
#  if openssl x509 -checkend $seconds_30d -noout -in $CERTS
#  then
#    :
#  else
#    temp_30d="$temp_30d$cert_name will expire on $cert_date\n"
#  fi
#done < $CERT_FILE

#send email notification
#if variables exist and are set to something, email to alert
#the "-e" in the echo command parses the "\n" linebreaks above
#if [ -n "$temp_07d" ]
#then
#  echo -e $temp_07d | mail -s "Certificates expiring in 07 days or less on $HOSTNAME" -r "shelkeashok9@gmail.com" $RECIPIENT
#elif [ -n "$temp_30d" ]
#then
#  echo -e $temp_30d | mail -s "Certificates expiring in 30 days or less on $HOSTNAME" -r "shelkeashok9@gmail.com" $RECIPIENT
#else
#    :
#fi

#send slack notification
#if SLACK_URL variables exist and are set to something, send notification to slack channel via webhook
#the "-e" in the echo command parses the "\n" linebreaks above
if [ -n "$temp_01d" ]
then
  curl -X POST -H 'Content-type: application/json' --data "{\"text\": \" WARNING!!! Certificates expiring in 01 days or less on $HOSTNAME \n ${temp_01d}\"}" $SLACK_URL
elif [ -n "$temp_07d" ]
then
  curl -X POST -H 'Content-type: application/json' --data "{\"text\": \"Attention!!! Certificates expiring in 07 days or less on $HOSTNAME \n ${temp_07d}\"}" $SLACK_URL
else
    :
fi

exit