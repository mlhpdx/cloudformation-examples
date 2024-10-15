set -xe

aws cloudformation package \
  --template-file templates/global.template \
  --s3-bucket ${BUCKET_NAME} \
  --s3-prefix ${BUCKET_PREFIX:-temp/gx} \
  --output-template-file global.template.packaged \
  --region ${AWS_REGION}

aws cloudformation deploy \
--template-file global.template.packaged \
--stack-name delete-me-gx  \
--parameter-overrides "DomainName=${DOMAIN_NAME}" \
  --region ${AWS_REGION}

aws cloudformation describe-stacks \
  --stack-name delete-me-gx \
  --query "Stacks[0].Outputs" \
  --region ${AWS_REGION} \
  > global.outputs
