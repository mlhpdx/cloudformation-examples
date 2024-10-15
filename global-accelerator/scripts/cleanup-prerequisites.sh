set -ex

if (aws cloudformation describe-stacks --stack-name delete-me-gx-prerequisites --no-paginate --region ${AWS_REGION} > /dev/null); then
  aws cloudformation delete-stack --stack-name delete-me-gx-prerequisites --region ${AWS_REGION}
  echo "Clean-up of prerequisites stack complete."
else
  echo "*** Skipping clean-up of stack 'delete-me-gx-prerequisites' since it doesn't exist in region ${AWS_REGION}. ***"
fi

