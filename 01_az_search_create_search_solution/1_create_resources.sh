source config.sh

echo "Creating RG $az_rg_name"
az group create --name $az_rg_name --location $az_region -o none

echo "Creating storage account $az_storage_account_name"
az storage account create -n $az_storage_account_name -g $az_rg_name  --sku Standard_LRS -o none

echo "Creating storage container $az_storage_container_name"
az storage container create --account-name $az_storage_account_name --name $az_storage_container_name -o none

echo "Creating search service $az_search_service_name"
az search service create -n $az_search_service_name -g $az_rg_name --sku Standard --partition-count 1 --replica-count 1 -o none

echo "Creating cognitive service account $az_cognitive_service_account_name"
az cognitiveservices account create --name $az_cognitive_service_account_name -g $az_rg_name --kind CognitiveServices --sku S0 -l $az_region --yes -o none