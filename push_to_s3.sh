#!/bin/bash
date=`date +%Y%m%d`
dateFormatted=`date -R`
s3Bucket=""
s3StorageType="REDUCED_REDUNDANCY"
s3Region="s3.us-east-1"

fileName=$1
fileType="image/jpeg"
fileSize=`stat -c%s ${fileName}`

relativePath="/${s3Bucket}/img/webcam/${fileName}"
acl="x-amz-acl:public-read"
storage_type="x-amz-storage-class:${s3StorageType}"
stringToSign="PUT\n\n${fileType}\n${dateFormatted}\nx-amz-acl:public-read\n${relativePath}"
s3AccessKey=""
s3SecretKey=""
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3SecretKey} -binary | base64`

#
#       Upload image to S3 bucket
#
curl -X PUT -T ${fileName} \
-H "Host: ${s3Bucket}.${s3Region}.amazonaws.com" \
-H "Date: ${dateFormatted}" \
-H "Content-Length: ${fileSize}" \
-H "Content-Type: ${fileType}" \
-H "x-amz-acl: public-read" \
-H "Authorization: AWS ${s3AccessKey}:${signature}" \
http://${s3Bucket}.${s3Region}.amazonaws.com/img/webcam/${fileName}
