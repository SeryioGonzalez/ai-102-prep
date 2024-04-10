source ../config.sh

sleep_time=2

AZ_SEARCH_ADMIN_KEY=$(az search admin-key show -g $az_rg_name --service-name $az_search_service_name --query primaryKey -o tsv)
AZ_COGNITIVE_SERVICE_KEY=$(az cognitiveservices account keys list -g $az_rg_name -n $az_cognitive_service_account_name --query key1 -o tsv)

echo "Updating the skillset"
echo "TODO - CREATE AZ FUNCTION AND PASS URL"
jq --arg az_cognitive_service_key $AZ_COGNITIVE_SERVICE_KEY '.cognitiveServices.key=$az_cognitive_service_key' update-skillset.json > temp.json && mv temp.json update-skillset.json
jq --arg az_search_skillset_name $az_search_skillset_name   '.name=$az_search_skillset_name'                   update-skillset.json > temp.json && mv temp.json update-skillset.json
curl -s -X PUT "$az_search_service_url/skillsets/$az_search_skillset_name?api-version=2020-06-30" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @update-skillset.json > /dev/null
sleep $sleep_time

echo "Updating the index"
jq --arg az_search_index_name $az_search_index_name '.name=$az_search_index_name' update-index.json > temp.json && mv temp.json update-index.json
curl -s -X PUT "$az_search_service_url/indexes/$az_search_index_name?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @update-index.json > /dev/null
sleep $sleep_time

echo "Updating the indexer"
jq --arg az_search_indexer_name     $az_search_indexer_name     '.name=$az_search_indexer_name'               update-indexer.json > temp.json && mv temp.json update-indexer.json
jq --arg az_search_data_source_name $az_search_data_source_name '.dataSourceName=$az_search_data_source_name' update-indexer.json > temp.json && mv temp.json update-indexer.json
jq --arg az_search_skillset_name    $az_search_skillset_name    '.skillsetName=$az_search_skillset_name'      update-indexer.json > temp.json && mv temp.json update-indexer.json
jq --arg az_search_index_name       $az_search_index_name       '.targetIndexName=$az_search_index_name'      update-indexer.json > temp.json && mv temp.json update-indexer.json
curl -s -X PUT "$az_search_service_url/indexers/$az_search_indexer_name?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @update-indexer.json > /dev/null
sleep $sleep_time

echo "Resetting the indexer"
curl -s -X POST "$az_search_service_url/indexers/$az_search_indexer_name/reset?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "Content-Length: 0" -H "api-key: $AZ_SEARCH_ADMIN_KEY" #> /dev/null
sleep $sleep_time

echo "Re-running the indexer"
curl -s -X POST "$az_search_service_url/indexers/$az_search_indexer_name/run?api-version=$az_search_api_version"   -H "Content-Type: application/json" -H "Content-Length: 0" -H "api-key: $AZ_SEARCH_ADMIN_KEY" #> /dev/null
sleep $sleep_time
