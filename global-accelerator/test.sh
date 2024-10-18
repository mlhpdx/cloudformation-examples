set -e

echo "Testing GX A:"
GXA_IPS=$(jq -r ".[]|select(.OutputKey==\"GxAIPv4s\")|.OutputValue" global.outputs)

for port in 80 443; do
    for ip in ${GXA_IPS}; do
        echo "Testing port ${port} on ${ip}"
        echo " - Command: ncat ${ip} ${port}"
        TEST=$((echo "test for port ${port} on ${ip}"; sleep 1) | ncat ${ip} ${port})
        echo " - Result: ${TEST}"
    done
done

echo "Testing GX B:"
GXB_IPS=$(jq -r ".[]|select(.OutputKey==\"GxBIPv4s\")|.OutputValue" global.outputs)

for port in 1468; do
    for ip in ${GXB_IPS}; do
        echo "Testing port ${port} on ${ip}"
        echo " - Command: ncat ${ip} ${port}"
        TEST=$((echo "test for port ${port} on ${ip}"; sleep 1) | ncat ${ip} ${port})
        echo " - Result: ${TEST}"
    done
done

echo "Testing GX C:"
GXC_IPS=$(jq -r ".[]|select(.OutputKey==\"GxCIPv4s\")|.OutputValue" global.outputs)

for port in 1812 1813 3799 2083; do
    for ip in ${GXC_IPS}; do
        echo "Testing port ${port} on ${ip}"
        echo " - Command: ncat ${ip} ${port}"
        TEST=$((echo "test for port ${port} on ${ip}"; sleep 1) | ncat ${ip} ${port})
        echo " - Result: ${TEST}"
    done
done
