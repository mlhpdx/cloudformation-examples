set -xe

# NOTE: to clean up the prerequitites, GLOBAL_REGION and LISTENER_REGIONS
# *must* be set the same as they were when `deploy.sh` was run.  If they
# aren't, some stacks may not be cleaned-up correctly.  Uncomment the lines
# below to set the variables as they are by default in `deploy.sh`.
#
GLOBAL_REGION=us-east-1
LISTENER_REGIONS="us-east-1 us-west-2 eu-west-1"

# clean up each of the regional stacks (EPGs, Instances)
for region in ${LISTENER_REGIONS}; do
  AWS_REGION=${region} . ./scripts/cleanup-region.sh
done

# clean up the global resources (GX, IAM, DNS)
AWS_REGION=${GLOBAL_REGION} . ./scripts/cleanup-global.sh

# cleanup prerequisites
AWS_REGION=${GLOBAL_REGION} . ./scripts/cleanup-prerequisites.sh

echo
echo "### Clean-up COMPLETE. ###"