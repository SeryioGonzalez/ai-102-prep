source config.sh

echo "Uploading files..."
az storage blob upload-batch -d $az_storage_container_name -s $local_data_folder --account-name $az_storage_account_name

