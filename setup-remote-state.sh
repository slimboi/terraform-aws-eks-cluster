#!/bin/bash

export AWS_PAGER=""

# Define variables
AWS_REGION="ap-southeast-2"
S3_BUCKET_NAME="myapp-terraform-state-1285"
# DYNAMODB_TABLE_NAME="myapp-terraform-locks"
PROFILE="default"  # Optional: customize your AWS profile

# Check for AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Exiting."
    exit 1
fi

# Validate required variables
if [[ -z "$S3_BUCKET_NAME" ]]; then
    echo "❌ Please set S3_BUCKET_NAME."
    exit 1
fi

echo "🚀 Starting Remote State Setup..."

# Create S3 Bucket
if aws s3api head-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --profile "$PROFILE" 2>/dev/null; then
    echo "✅ S3 bucket '$S3_BUCKET_NAME' already exists."
else
    echo "🪣 Creating S3 bucket: $S3_BUCKET_NAME"
    aws s3api create-bucket --bucket "$S3_BUCKET_NAME" \
    --region "$AWS_REGION" \
    --profile "$PROFILE" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION" \
    > /dev/null 2>&1 || echo "⚠️ Warning: Bucket may already exist or an error occurred."
fi

# # Create DynamoDB Table
# if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE_NAME" --region "$AWS_REGION" --profile "$PROFILE" &>/dev/null; then
#     echo "✅ DynamoDB table '$DYNAMODB_TABLE_NAME' already exists."
# else
#     echo "📦 Creating DynamoDB table: $DYNAMODB_TABLE_NAME"
#     aws dynamodb create-table --table-name "$DYNAMODB_TABLE_NAME" \
#     --region "$AWS_REGION" \
#     --profile "$PROFILE" \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
#     > /dev/null 2>&1 \
#     && echo "✅ DynamoDB table created." \
#     || echo "⚠️ Failed to create DynamoDB table."
# fi

echo "🎉 Remote State Setup Completed Successfully!"