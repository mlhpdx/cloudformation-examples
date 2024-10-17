set -xe

# reformat the global stack outputs and combine with the regional configuration
jq ".[0] * {GlobalOutputs:([.[1][]|{(.OutputKey):.OutputValue}]|add)}" -s config/region-config.json global.outputs > region-config.json.combined

aws cloudformation package \
  --template-file templates/region.template \
  --s3-bucket ${BUCKET_NAME} \
  --s3-prefix ${BUCKET_PREFIX:-temp/gx} \
  --output-template-file region.template.packaged \
  --region ${AWS_REGION}

aws cloudformation deploy \
  --template-file region.template.packaged \
  --stack-name delete-me-gx-region  \
  --capabilities CAPABILITY_IAM \
  --region ${AWS_REGION}
