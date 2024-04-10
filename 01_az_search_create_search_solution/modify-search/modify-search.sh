source ../config.sh

sleep_time=2

AZ_SEARCH_ADMIN_KEY=$(az search admin-key show -g $az_rg_name --service-name $az_search_service_name --query primaryKey -o tsv)
AZ_COGNITIVE_SERVICE_KEY=$(az cognitiveservices account keys list -g $az_rg_name -n $az_cognitive_service_account_name --query key1 -o tsv)

echo "Updating the skillset"
jq --arg az_cognitive_service_key $AZ_COGNITIVE_SERVICE_KEY '.cognitiveServices.key=$az_cognitive_service_key' skillset.json > temp.json && mv temp.json skillset.json
curl -X PUT "$az_search_service_url/skillsets/margies-skillset?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @skillset.json
sleep $sleep_time

echo "Updating the index"
curl -X PUT "$az_search_service_url/indexes/margies-index?api-version=2024-03-01-Preview" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @index.json
sleep $sleep_time

echo "Updating the indexer"
curl -X PUT "$az_search_service_url/indexers/margies-indexer?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @indexer.json
sleep $sleep_time

echo "Resetting the indexer"
curl -X POST "$az_search_service_url/indexers/margies-indexer/reset?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "Content-Length: 0" -H "api-key: $AZ_SEARCH_ADMIN_KEY" 
sleep $sleep_time

echo "Rerunning the indexer"
curl -X POST "$az_search_service_url/indexers/margies-indexer/run?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "Content-Length: 0" -H "api-key: $AZ_SEARCH_ADMIN_KEY" 
