# Cloudformation Examples

This repo contains examples of using CloudFormation (and SAM) that might be useful for others. Only two so far:

* HTTP Headers aren't automatically passed to your backend when using API Gateway with Lambda.  So, [./apigw-to-lambda-any-header](apigw-to-lambda-any-header) provides an example of an HTTP API that passes the `Range` header.

* Global Accelerator is a fantastic service, but setting it up in CloudFormation is non-trivial. So, [/global-accelerator]() provides an example of a "close to real world" deployment approach.

