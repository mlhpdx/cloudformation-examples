set -xe

if [[ -n "${BUCKET_NAME}" ]] && [[ -n "${DOMAIN_NAME}" ]]; then
  echo "*** Both BUCKET_NAME and DOMAIN_NAME are set, so skipping deployment of prerequisites template. ***"
else
  aws cloudformation deploy \
  --template-file templates/prerequisites.template \
  --stack-name delete-me-gx-prerequisites  \
  --parameter-overrides \
    DomainName="${DOMAIN_NAME}" \
    BucketName=${BUCKET_NAME} \
  --no-fail-on-empty-changeset \
  --region ${AWS_REGION}

  aws cloudformation describe-stacks \
  --stack-name delete-me-gx-prerequisites \
  --query "Stacks[0].Outputs" \
  --region ${AWS_REGION} \
  > prerequisites.outputs

  # the stack outputs will be either the name given in the environment variable, or the name of
  # the resource created when no name was provided (so they can be set unconditionally here).
  export BUCKET_NAME=$(jq 'map(select(.OutputKey == "BucketName"))[0]|.OutputValue' -r prerequisites.outputs)
  export DOMAIN_NAME=$(jq 'map(select(.OutputKey == "DomainName"))[0]|.OutputValue' -r prerequisites.outputs)

  echo "Deployment of prerequisites stack complete (BUCKET_NAME is ${BUCKET_NAME}, DOMAIN_NAME is ${DOMAIN_NAME})."
fi
