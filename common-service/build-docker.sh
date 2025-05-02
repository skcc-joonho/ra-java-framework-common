#!/bin/bash

# Set variables
IMAGE_NAME="common-service"
IMAGE_TAG="latest"
REGISTRY="agsats.azurecr.io"  # Docker Hub 또는 private registry URL

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf common-export/build
rm -rf account-export/build
rm -rf common-service/build

# Build the image from the root directory
echo "Building Docker image..."
cd ..  # Move to the root directory
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f common-service/Dockerfile .

# Tag the image for registry
echo "Tagging image for registry..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

# ACR에 이미지 푸시
echo "Pushing image to ACR..."
docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

echo "Docker image build completed!" 