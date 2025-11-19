#!/bin/bash
# build-and-push.sh

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="eu-west-1"
REPO_NAME="devops-dev-tooling-repo"
TAG="clean-alpine-$(date +%Y%m%d-%H%M%S)"

# Create ECR repo if it doesn't exist
aws ecr describe-repositories --repository-names $REPO_NAME --region $REGION 2>/dev/null || \
  aws ecr create-repository --repository-name $REPO_NAME --region $REGION

# Login to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build and tag
docker buildx build --platform=linux/amd64 --output=type=image -t $REPO_NAME:$TAG .

# Tag as latest as well
docker tag $REPO_NAME:$TAG $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG
docker tag $REPO_NAME:$TAG $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest

# Push both tags
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG
#docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest

echo "✅ Pushed clean image with tags: $TAG and latest"
