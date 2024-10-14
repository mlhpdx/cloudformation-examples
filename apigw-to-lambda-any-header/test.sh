set -e

curl -s ${API_URL} > default_request.json
curl -s "${API_URL}" -H "Range: bytes=0-255" > range_request.json

echo Here are the headers seen by the lambda for a default request: $(jq ".Headers|keys|join(\",\")" default_request.json)
echo
echo Here are the headers seen for a request with a 'Range' header: $(jq ".Headers|keys|join(\",\")" range_request.json)
echo
echo Here is the diff: $(jq "(.[1].Headers|keys) - (.[0].Headers|keys)" -s default_request.json range_request.json)
