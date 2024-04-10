subscription_id="05107e90-31a7-4c23-a140-595770b8d99a"

context="sergioai102"
az_region="switzerlandnorth"

############################
az_rg_name=$context"-rg"
az_storage_account_name=$context"storage"
az_storage_container_name="margies"
az_search_service_name=$context"-search"
az_search_service_url="https://$az_search_service_name.search.windows.net"
az_search_api_version="2020-06-30"
az_cognitive_service_account_name=$context"-cognitiveservices"


local_data_folder="data"