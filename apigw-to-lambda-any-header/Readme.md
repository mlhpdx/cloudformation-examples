# Example API Gateway with Lambda Handler and Support for Any HTTP Header

Supporting some HTTP headers when using API Gateway and Lambda requires a little extra effort when using the Serverless Application Model (SAM).  This repo contains an example project that supports the HTTP 'Range' header by stepping outside the SAM idioms and using OpenAPI instead of logical CloudFormation resources (i.e. the only way to make this simple use case work AFAIK).

## Setup/Deployment

If you want to deploy and poke around with this example, it can be deployed using the `deploy.sh` script and torn down using the `cleanup.sh` script.  Just set the name of the S3 bucket (and optionally key prefix and region) that `cloudformation package` will use to upload the compiled lambda:

```bash
BUCKET_NAME = YOUR_BUCKET_NAME_HERE ./deploy.sh
```

To prove it works:
```bash
./test.sh
```

And, when you're done:

```bash
./cleanup.sh
```
