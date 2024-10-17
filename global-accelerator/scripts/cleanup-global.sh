set -ex

if (aws cloudformation describe-stacks --stack-name delete-me-gx --no-paginate --region ${AWS_REGION} > /dev/null); then
  aws cloudformation delete-stack --stack-name delete-me-gx --region ${AWS_REGION}
  aws cloudformation wait stack-delete-complete --stack-name delete-me-gx --region ${AWS_REGION}
  echo "Clean-up of global stack complete."
else
  echo "*** Skipping clean-up of stack 'delete-me-gx' since it doesn't exist in region ${AWS_REGION}. ***"
fi

