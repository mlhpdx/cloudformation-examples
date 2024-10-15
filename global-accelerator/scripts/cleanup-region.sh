set -xe

if (aws cloudformation describe-stacks --stack-name delete-me-gx-region --no-paginate --region ${AWS_REGION}) > /dev/null; then
  aws cloudformation delete-stack --stack-name delete-me-gx-region --region ${AWS_REGION}
  echo "Clean-up of region ${AWS_REGION} stack complete."
else
  echo "*** Skipping clean-up of stack 'delete-me-gx-region' since it doesn't exist in region ${AWS_REGION}. ***"
fi

