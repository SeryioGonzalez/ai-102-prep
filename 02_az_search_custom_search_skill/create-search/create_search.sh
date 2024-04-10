source ../config.sh

sleep_time=2

AZ_SEARCH_ADMIN_KEY=$(az search admin-key show -g $az_rg_name --service-name $az_search_service_name --query primaryKey -o tsv)
AZ_COGNITIVE_SERVICE_KEY=$(az cognitiveservices account keys list -g $az_rg_name -n $az_cognitive_service_account_name --query key1 -o tsv)
AZ_STORAGE_ACCOUNT_CONNECTION_STRING=$(az storage account show-connection-string -n $az_storage_account_name -g $az_rg_name --query connectionString -o tsv)

echo "Creating the data source"
jq --arg az_storage_account_connection_string $AZ_STORAGE_ACCOUNT_CONNECTION_STRING '.credentials.connectionString=$az_storage_account_connection_string' data_source.json > temp.json && mv temp.json data_source.json
jq --arg az_search_data_source_name           $az_search_data_source_name           '.name=$az_search_data_source_name'                                   data_source.json > temp.json && mv temp.json data_source.json
jq --arg az_storage_container_name            $az_storage_container_name            '.container.name=$az_storage_container_name'                          data_source.json > temp.json && mv temp.json data_source.json
curl -s -X POST "$az_search_service_url/datasources?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @data_source.json > /dev/null
sleep $sleep_time

echo "Creating the skillset"
jq --arg az_cognitive_service_key $AZ_COGNITIVE_SERVICE_KEY '.cognitiveServices.key=$az_cognitive_service_key' skillset.json > temp.json && mv temp.json skillset.json
jq --arg az_search_skillset_name $az_search_skillset_name   '.name=$az_search_skillset_name'                   skillset.json > temp.json && mv temp.json skillset.json
curl -s -X PUT "$az_search_service_url/skillsets/$az_search_skillset_name?api-version=2020-06-30" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @skillset.json > /dev/null
sleep $sleep_time

echo "Creating the index"
jq --arg az_search_index_name $az_search_index_name '.name=$az_search_index_name' index.json > temp.json && mv temp.json index.json
curl -s -X PUT "$az_search_service_url/indexes/$az_search_index_name?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @index.json > /dev/null
sleep $sleep_time

echo "Creating the indexer" 
jq --arg az_search_indexer_name     $az_search_indexer_name     '.name=$az_search_indexer_name'                     indexer.json > temp.json && mv temp.json indexer.json
jq --arg az_search_data_source_name $az_search_data_source_name '.dataSourceName=$az_search_data_source_name'       indexer.json > temp.json && mv temp.json indexer.json
jq --arg az_search_skillset_name    $az_search_skillset_name    '.skillsetName=$az_search_skillset_name'            indexer.json > temp.json && mv temp.json indexer.json
jq --arg az_search_index_name       $az_search_index_name       '.targetIndexName=$az_search_index_name'            indexer.json > temp.json && mv temp.json indexer.json
curl -s -X PUT "$az_search_service_url/indexers/$az_search_indexer_name?api-version=$az_search_api_version" -H "Content-Type: application/json" -H "api-key: $AZ_SEARCH_ADMIN_KEY" -d @indexer.json > /dev/null
