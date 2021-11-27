

#!/bin/sh

LOCATION=$1
RESOURCE_GROUP_NAME=$2
TAGS=$3
STORAGE_ACCOUNT_NAME=$4

echo "LOCATION: $LOCATION"
echo "RESOURCE_GROUP_NAME: $RESOURCE_GROUP_NAME"
echo "TAGS: $TAGS"
echo "STORAGE_ACCOUNT_NAME: $STORAGE_ACCOUNT_NAME"

# Create resource group for terraform storage 
az group create --location "$LOCATION" --name "$RESOURCE_GROUP_NAME" --tags "$TAGS"

# Create storage account for terraform  
az storage account create \
  --name "$STORAGE_ACCOUNT_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION" \
  --sku Standard_RAGRS \
  --kind StorageV2 \
  --tags "$TAGS"
