subscription_id="05107e90-31a7-4c23-a140-595770b8d99a"

context="marlies"
az_region="switzerlandnorth"

############################
az_rg_name=$context"-rg"
az_storage_account_name=$context"storageaccount"
az_storage_container_name=$context"-container"
az_search_service_name=$context"-search"
az_search_service_url="https://$az_search_service_name.search.windows.net"
az_search_api_version="2023-11-01"
az_search_index_name=$context"-custom-index"
az_search_indexer_name=$context"-custom-indexer"
az_search_skillset_name=$context"-custom-skillset"
az_search_data_source_name=$context"-custom-data"

az_cognitive_service_account_name=$context"-cognitiveservices"


local_data_folder="data"