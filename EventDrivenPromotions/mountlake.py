# Databricks notebook source
keyvault = "dev-keyVault"

# COMMAND ----------

storage_account_name = 'devstoragehackathonrgp'

# COMMAND ----------

lake_containers = ['bronze', 'silver', 'gold']

# COMMAND ----------

tenantid = dbutils.secrets.get(scope = keyvault, key = "service-principal-tenantid")

# COMMAND ----------

configs = {
    "fs.azure.account.auth.type": "OAuth",
    "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id": dbutils.secrets.get(scope = keyvault, key = "service-principal-app-id"),
    "fs.azure.account.oauth2.client.secret": dbutils.secrets.get(scope = keyvault, key = "service-principal-app-secret"),
    "fs.azure.account.oauth2.client.endpoint": f"https://login.microsoftonline.com/{tenantid}/oauth2/token"
}

# COMMAND ----------

for container in lake_containers:
    dbutils.fs.mount(
        source = f"abfss://{container}@{storage_account_name}.dfs.core.windows.net/",
        mount_point = f"/mnt/{container}",
        extra_configs = configs
    )

# COMMAND ----------

dbutils.fs.ls('/mnt/bronze')

# COMMAND ----------

