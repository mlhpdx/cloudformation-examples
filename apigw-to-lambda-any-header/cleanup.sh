aws cloudformation delete-stack \
  --stack-name delete-me-api \
  --region ${AWS_REGION:-us-east-1}

export API_URL=