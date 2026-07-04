#!/usr/bin/env bash
# Faz login do Docker no ECR privado da conta/região. Sem segredos no script.
set -euo pipefail
REGION="${AWS_REGION:-us-east-1}"
ACCOUNT="$(aws sts get-caller-identity --query Account --output text)"
REGISTRY="${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"
echo ">> Login no ECR: ${REGISTRY}"
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$REGISTRY"
echo ">> OK. Ex.: docker push ${REGISTRY}/bookloop-api:latest"
