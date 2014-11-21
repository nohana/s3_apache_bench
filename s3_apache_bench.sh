#!/bin/bash
file="$1"

key_id="hoge"
key_secret="huga"
path="some-directory/$file"
bucket="hoge"
content_type="image/jepg"
date="$(LC_ALL=C date -u +"%a, %d %b %Y %X %z")"
md5="$(openssl md5 -binary < "$file" | base64)"

sig="$(printf "PUT\n$md5\n$content_type\n$date\n/$bucket/$path" | openssl sha1 -binary -hmac "$key_secret" | base64)"

ab  -w -n 5 -c 1 -v 4 -H "Date: $date" \
    -H "Authorization: AWS $key_id:$sig" \
    -H "Content-Type: $content_type" \
    -H "Content-MD5: $md5" \
    -p "IMG_1257.JPG" https://"$bucket".s3.amazonaws.com/test

