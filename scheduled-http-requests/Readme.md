# Scheduled HTTP Requests with "Inside-Out" API Gateway

Access external APIs from AWS without VPCs, NAT Gateways, or EC2 instances.

## The Problem

Traditional approaches are expensive and complex:
- **Lambda in VPC** → Requires NAT Gateway (~$32+/month even when idle)
- **EC2/ECS in VPC** → VPC setup, NAT Gateway, instance management
- **Fargate in VPC** → NAT Gateway plus container orchestration

All share the same issues: NAT Gateways cost money 24/7, VPC networking adds complexity, and more infrastructure means more to manage and secure.

## The Solution

Use API Gateway as an HTTP proxy with Step Functions for orchestration. API Gateway already has internet access—leverage it "inside-out" to make external requests without VPC networking.

### Architecture

![Architecture Diagram](architecture.png)

**Flow:**
1. EventBridge schedule triggers Step Functions state machine
2. State machine invokes API Gateway with HTTP integration
3. API Gateway proxies request to external API
4. Response flows back through the chain for optional processing/storage

### Why This Wins

| Aspect | VPC + NAT | Inside-Out Gateway |
|--------|-----------|-------------------|
| **Monthly cost (1K calls/day)** | ~$32+ | ~$0.08 |
| **Setup** | VPC, subnets, routes, NAT, SGs | API Gateway + Step Functions |
| **Management** | Patching, scaling, monitoring | Fully managed |
| **Security surface** | OS, dependencies, network config | IAM policies only |
| **Compromisable resources** | Instances, containers, Lambda runtime | None |

## Security Advantages

This pattern is inherently more secure:

- **No patchable infrastructure** - No OS or dependency updates to manage, nothing to compromise
- **Controlled external access** - When combined with a VPC without public subnets, all external access routes through API Gateway with IAM authentication
- **Least privilege by default** - Each Step Function can only invoke specific API Gateway endpoints via IAM
- **No network attack surface** - No instances or containers that could be exploited
- **Full audit trail** - All requests logged in CloudWatch and CloudTrail

For maximum security, use this pattern with a fully private VPC (no public subnets, no NAT Gateway). Resources in the VPC can only make external requests through API Gateway endpoints you explicitly authorize via IAM policies.

## What Gets Deployed

- API Gateway REST API with HTTP proxy integrations
- Step Functions state machines for orchestration
- EventBridge schedules for automation
- IAM roles with least-privilege access
- CloudWatch Logs for monitoring

## Prerequisites

- AWS CLI configured
- AWS SAM CLI ([install guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html))
- S3 bucket for deployment artifacts

## Deployment

```bash
sam build
sam deploy --guided
```

Verify:
```bash
aws cloudformation describe-stacks --stack-name <your-stack-name>
```

## Usage

Manual trigger:
```bash
aws stepfunctions start-execution \
  --state-machine-arn <arn> \
  --input '{}'
```

View executions:
```bash
aws stepfunctions list-executions --state-machine-arn <arn>
```

## Extending

**Add new APIs:** Add HTTP integration in API Gateway template, create corresponding state machine

**Process responses:** Modify state machines to store in S3/DynamoDB, detect changes, transform data, or send alerts

**Custom schedules:** Update EventBridge rules for different frequencies or parameters

## Use Cases

- Monitor external APIs for availability
- Poll data from public APIs (weather, stock prices, RSS)
- Detect website content changes
- Verify third-party integrations
- Compliance and SLA monitoring

## When to Use This Pattern

**Use inside-out API Gateway when:**
- Polling external APIs on a schedule
- Avoiding NAT Gateway costs
- Preferring serverless, pay-per-use pricing
- Wanting simple IAM-based security

**Use traditional VPC when:**
- External API requires connections from specific IPs (need NAT + Elastic IP)
- Integrating with on-premises via Direct Connect/VPN
- Compliance requires VPC-level network isolation

## Cleanup

```bash
aws cloudformation delete-stack --stack-name <your-stack-name>
```