# Databricks notebook source
keyvault = "dev-keyVault"

# COMMAND ----------

lake_containers = ['bronze', 'silver', 'gold']

# COMMAND ----------

for container in lake_containers:
    dbutils.fs.unmount(f"/mnt/{container}")

# COMMAND ----------

dbutils.fs.ls('/mnt/')

# COMMAND ----------

