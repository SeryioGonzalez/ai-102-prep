source config.sh

echo "Deleting RG $az_rg_name"
az group delete --name $az_rg_name -y --no-wait -o none