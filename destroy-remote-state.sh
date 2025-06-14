#!/bin/bash

# Disable AWS CLI paging and suppress unnecessary output
export AWS_PAGER=""

# Define variables — ensure these match the resources created
AWS_REGION="ap-southeast-2"
S3_BUCKET_NAME="myapp-terraform-state-1285"
# DYNAMODB_TABLE_NAME="myapp-terraform-locks"
PROFILE="default"

echo "🚨 Starting Remote State Cleanup..."

# 🪣 Check if the S3 bucket exists
if aws s3api head-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --profile "$PROFILE" > /dev/null 2>&1; then
    echo "🧹 Emptying S3 bucket: $S3_BUCKET_NAME"
    aws s3 rm "s3://$S3_BUCKET_NAME" --recursive --region "$AWS_REGION" --profile "$PROFILE" > /dev/null

    echo "🗑️ Deleting S3 bucket: $S3_BUCKET_NAME"
    aws s3api delete-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --profile "$PROFILE" > /dev/null
    echo "✅ S3 bucket deleted successfully."
else
    echo "⚠️ S3 bucket '$S3_BUCKET_NAME' does not exist or is inaccessible."
fi

# # Uncomment if you're managing a DynamoDB table for state locking
# if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE_NAME" --region "$AWS_REGION" --profile "$PROFILE" &>/dev/null; then
#     echo "🗑️ Deleting DynamoDB table: $DYNAMODB_TABLE_NAME"
#     aws dynamodb delete-table --table-name "$DYNAMODB_TABLE_NAME" --region "$AWS_REGION" --profile "$PROFILE" > /dev/null
#     echo "✅ DynamoDB table deleted successfully."
# else
#     echo "⚠️ DynamoDB table '$DYNAMODB_TABLE_NAME' does not exist."
# fi

echo "✅ Remote State Cleanup Completed!"