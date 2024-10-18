set -ex

# if deploy-prerequisites.sh created the bucket we need to remove all of the objects before 
# the stack can be deleted.  If it was an existing bucket, we'll still be nice and clean
# up any objects we put in it.
export BUCKET_NAME=$(jq 'map(select(.OutputKey == "BucketName"))[0]|.OutputValue' -r prerequisites.outputs)
aws s3 rm --recursive s3://${BUCKET_NAME}/${BUCKET_PREFIX:-temp/delete-me-gx} --region ${AWS_REGION} || true

if (aws cloudformation describe-stacks --stack-name delete-me-gx-prerequisites --no-paginate --region ${AWS_REGION} > /dev/null); then
  aws cloudformation delete-stack --stack-name delete-me-gx-prerequisites --region ${AWS_REGION}
  aws cloudformation wait stack-delete-complete --stack-name delete-me-gx-prerequisites --region ${AWS_REGION}
  echo "Clean-up of prerequisites stack complete."
else
  echo "*** Skipping clean-up of stack 'delete-me-gx-prerequisites' since it doesn't exist in region ${AWS_REGION}. ***"
fi

