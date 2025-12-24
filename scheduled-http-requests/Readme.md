# Scheduled HTTP Requests Example

This folder contains an example solution for polling external websites from within AWS using an "inside out" API Gateway approach. Instead of using VPCs, EC2 instances, or container tasks, this pattern leverages API Gateway, EventBridge, and Step Functions to securely and efficiently access external APIs and websites.

## Approach

- **API Gateway** is configured to act as an HTTP proxy for external sites (e.g., GitHub, weather.gov).
- **Step Functions state machines** orchestrate requests to these APIs, track success/failure, and can be easily extended to process, store, or diff responses.
- **EventBridge schedules** trigger the state machines at regular intervals, enabling automated polling of external resources.

This approach is:
- **Simpler**: No need to manage VPCs, NAT gateways, or EC2/container lifecycle.
- **Safer**: Uses IAM roles and API Gateway for secure, auditable access.
- **More efficient**: No always-on infrastructure; pay only for executions.

## Prerequisites
- AWS CLI configured with appropriate permissions
- AWS SAM CLI installed
- An S3 bucket for deployment artifacts
- (No IAM roles need to be provided; all required roles are created by the template.)

## Deployment Steps
1. Build the SAM application:
   ```sh
   sam build
   ```
2. Deploy the stack (guided mode recommended):
   ```sh
   sam deploy --guided
   ```
   - Provide required parameters (contact email, etc.)
   - Choose a stack name and S3 bucket for artifacts

## Extending the Solution
- **Add new APIs**: Update the endpoints template and create new state machines for other sites.
- **Custom processing**: Modify the state machine definitions to store, diff, or process responses as needed.
- **Flexible scheduling**: Add or adjust EventBridge rules to poll resources at different intervals or with different payloads.

## Teardown
To remove all resources when no longer needed:
```sh
aws cloudformation delete-stack --stack-name <your-stack-name>
```
Or use the AWS Console to delete the deployed stack.

## Example Use Cases
- Monitor websites and APIs for availability
- Pull periodic data from websites and APIs
- Integrate with other public APIs for reporting, monitoring, or automation

---
This example demonstrates a modern, serverless approach to polling and processing external data from AWS, with minimal infrastructure and maximum flexibility.
