
var="PLACEHOLDER"

jq --arg var $var '.cognitiveServices.key=$var'        02_az_search_custom_search_skill/update-search/update-skillset.json                                      > temp.json && mv temp.json 02_az_search_custom_search_skill/update-search/update-skillset.json
jq --arg var $var '.skills |= map(if .name == "get-top-words" then .uri = $var else . end)' 02_az_search_custom_search_skill/update-search/update-skillset.json > temp.json && mv temp.json 02_az_search_custom_search_skill/update-search/update-skillset.json
jq --arg var $var '.credentials.connectionString=$var' 02_az_search_custom_search_skill/create-search/data_source.json                                          > temp.json && mv temp.json 02_az_search_custom_search_skill/create-search/data_source.json

jq --arg var $var '.credentials.connectionString=$var'           03_az_search_knowledge_store/create-search/data_source.json         > temp.json && mv temp.json 03_az_search_knowledge_store/create-search/data_source.json
jq --arg var $var '.cognitiveServices.key=$var'                  03_az_search_knowledge_store/create-search/skillset.json            > temp.json && mv temp.json 03_az_search_knowledge_store/create-search/skillset.json
jq --arg var $var '.knowledgeStore.storageConnectionString=$var' 03_az_search_knowledge_store/create-search/skillset.json            > temp.json && mv temp.json 03_az_search_knowledge_store/create-search/skillset.json