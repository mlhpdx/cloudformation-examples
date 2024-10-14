set -xe

sam build \
  --template-file api.template \

sam deploy \
  --stack-name delete-me-api \
  --s3-bucket ${BUCKET_NAME} \
  --s3-prefix ${BUCKET_PREFIX:-temp/api} \
  --capabilities CAPABILITY_IAM \
  --region ${AWS_REGION:-us-east-1}

export API_URL=$(aws cloudformation describe-stacks \
  --stack-name delete-me-api \
  --region ${AWS_REGION:-us-east-1} \
  | jq ".Stacks[0].Outputs[0].OutputValue" -r)