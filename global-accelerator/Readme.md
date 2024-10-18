# Example Global Accelerator

This repo contains an example of how to setup Global Accelerators with listeners, and Endpoint Groups backed by EC2 in multiple regions. The approach here is relatively simple, easy to maintain and configure, and somewhat a "real" setup from the GX perspective.

## Quick Start

Clone the repo locally, then from a bash prompt at the root of the repo run:

```bash
./deploy.sh
```

After the script runs you should have three Accelerators in your AWS account. You can grab the IP addresses of the Accelerators from the `global.outputs` file to test. Note that all the listeners simply act as echo services (setting-up each of the services is "left to the reader").

```bash
./test.sh
```

The resources created in the deployment can be cleaned-up by running:

```bash
./cleanup.sh
```

## Choosing Regions

Since GX uses both "global" (not associated with a region) and "regional" resources, the repo has two different templates: global.template and region.template which are responsible for their respective parts of the system, and must be deployed once and once per region, respectively. \

By default, the solution creates the global resources in the `us-east-1` region, and regional resources in each of `us-east-1`, `us-west-2` and `eu-west-`.  To customize the regions used, edit the values for `GLOBAL_REGION` and `LISTENER_REGIONS` in the `deploy.sh` and `cleanup.sh` scripts, and add properties to `config/region-config.json` for any regions not represented there.

## BYOB(ucket) and "real" Domain

By default this solution creates a HostedZone called "not-a-real-domain.net", which probably won't be resolvable. You can specify a custom domain name (i.e. one you own) for the GX by setting the environment variable `DOMAIN_NAME` before running `./deploy.sh`. In that case you'll get subdomain names for each GX that can be used for real, and still have global IP addresses (the best of both worlds).

This solution also creates a bucket for deployment artifacts (e.g. the output of SAM). If you want to use a bucket of your own, just set the environment variable `BUCKET_NAME` prior to running the deploy script.  You can also set the environment variable `BUCKET_PREFIX` to specify where in the bucket the artifacts will be created (maps to the `--s3-prefix` command option for the SAM and AWS CLIs).

## More Deployment Information and Options

To make this example closer to a "real world" use of GX the solution creates multiple GX Accelerators with multiple listeners. This reflects, perhaps, what a DevOps team would need to run Accelerators for web applications, syslog and RADIUS all with one IoC setup.

To control the configuation, see the JSON configuration files imported into the template's `Mappings` section with `Fn::Include`. The `global-config.json` file specifies the number and setup of Accelerators, including subdomain names, listeners (ports) supported and whether listeners should be created in each region (`RegionConditionals`). Using this file new Accelerators and Listeners can be added and removed. 

Likewise, the `region-config.json` file contains configuration information imported into the mapping section of `region.template`, and specifies region-specific information like the AMI to use for EC2 instances. But, to keep things simple (and inexpensive to experiment with), all of the listeners in this example (UDP and TCP) route traffic to a single EC2 instance in each region that will echo requests. 

## FYI #1

This example creates it's own VPC to keep things separate rather than using the default VPC in your account. Using a non-default VPC creates a couple issues, though (see below) which made it interesting.

## FYI #2

This repo is obviously done as Infrastructure as Code (IaC), and that's great.  What's less great is finding gaps in CloudFormation that make it more difficult than it should be.  Two particular "gotchas" came up in the project:

1) Global Accelerator kindly creates a special Security Group named "GlobalAccelerator" that makes it each to allow traffic to backends via an ingress rule.  Unfortunately the ID of that Security Group isn't discoverable in CloudFormation (only security groups in the default VPC can be found by name, otherwise the ID has to be used).
2) Instance Connect kindly publishes a Prefix List to similarly make allowing SSH from that service easier.  But, again, Cloudformation provides no way to get the ID of that prefix list (which is needed for the ingress rule).

The solution to both problems is to build a Custom Resource into the template that can grab those IDs. It works, kinda. Have a look at `ResourceFinder` in `templates/region.template` if you're interested.

## FYI #3

This solution uses `Fn::ForEach` liberally.  But you'll notice that the EC2 user data script in the `LaunchTemplate` resource of `templates/region.template` hard-codes all of the port numbers. Why not use `Fn::ForEach` and `Fn::Join` to build those commands from the configuration data as is done elsewhere?  Unfortunately, `Fn::ForEach` doesn't support adding elements to an array rather than properties of an object.  You can pop over to [my version](https://github.com/mlhpdx/cloudformation-macros) of `ForEach` that does allow for expansion into arrays (I didn't use it in this example to avoid the dependency). 

If you think it'd be good if `AWS::LanguageExtensions` also supported array output, consider a +1 on point #6 of [this issue on their repo](https://github.com/aws-cloudformation/cfn-language-discussion/issues/118).

