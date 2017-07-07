#!/bin/bash


host=$1

while :; do
date +%s

# Download
ssh ubnt@$host 'megas=1;dd if=/dev/zero bs=4096 count=$((1024*$megas/4))' | cat > /dev/null
echo Download 

sleep 10

# Upload
megas=1; dd if=/dev/zero bs=4096 count=$((1024*$megas/4)) | ssh ubnt@$host 'cat > /dev/null'
echo Upload 

sleep 900

done
