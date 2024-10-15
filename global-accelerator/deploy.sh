set -xe

# the environment variables GLOBAL_REGION and LISTENER_REGIONS control where things
# in this stack are deployed. If you add a new region here you'll also want to
# add it in `region-config.json`. These values are exported so they will remain
# available when `cleanup.sh` is run.
export GLOBAL_REGION=us-east-1
export LISTENER_REGIONS="us-east-1 us-west-2 eu-west-1"

# if BUCKET_NAME or DOMAIN_NAME aren't specified, create temporary ones now.
# since packaged templates will upload to this bucket it may be necessary
# to clean it up manually (the stack delete may fail because the bucket isn't
# empty). 
AWS_REGION=${GLOBAL_REGION} . ./scripts/deploy-prerequisites.sh

# deploy the global resources needed for this example (GX, IAM, DNS)
AWS_REGION=${GLOBAL_REGION} . ./scripts/deploy-global.sh

# deploy each of the regional stacks (EPGs, Instances)
for region in ${LISTENER_REGIONS}; do
  AWS_REGION=${region} . ./scripts/deploy-region.sh
done

echo
echo "### Deployment COMPLETE. You may run 'cleanup.sh' to tear it all down. ###"