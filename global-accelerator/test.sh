set -e

GXA_IPS=$(jq -r ".[]|select(.OutputKey==\"GxAIPv4s\")|.OutputValue" global.outputs)

for port in 80 443; do
    for ip in ${GXA_IPS}; do
        TEST=$((echo "test port ${port} on ${ip}"; sleep 1) | ncat ${ip} 80)
        echo "${TEST}"
    done
done
