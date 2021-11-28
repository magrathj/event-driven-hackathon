# Databricks notebook source
# MAGIC %sql
# MAGIC CREATE DATABASE IF NOT EXISTS reference;

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE DATABASE IF NOT EXISTS silver;

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE DATABASE IF NOT EXISTS gold;

# COMMAND ----------

# MAGIC %sql
# MAGIC USE reference 

# COMMAND ----------

from pyspark.sql.functions import *
from pyspark.sql.types import *

# COMMAND ----------

store_df = spark.createDataFrame([("abcde-j12345-e12345-f12345","London","Tesco","Coffee Shop", "53.5", "0.82"),
                            ("defgh-j12345-e12345-i12345","Piccadily","Costa","Coffee Shop", "53.5", "0.82"),
                            ("jhijk-j12345-e12345-l12345","Amersham","Starbucks","Coffee Shop", "53.5", "0.82"),
                            ("lmnop-j12345-e12345-q12345","Borough","EatAway","Restaurant", "53.5", "0.82"),
                            ("mnopq-j12345-e12345-r12345","Greenwich","prufrock coffee","Coffee Shop", "53.5", "0.820000000000001"),
                            ("pqrst-j12345-e12345-u12345","Paddington","Macdonalds","Restaurant", "53.5", "0.820000000000001"),
                            ("rstuv-j12345-e12345-w12345","Rochester","EatQuick","Dining", "53.5", "0.820000000000001"),
                            ("tuvwx-j12345-e12345-y12345","Rainham","KissTheHippo","Coffee Shop", "53.5", "0.820000000000001"),
                           ],['StoreId','Location','Merchant','ServiceType',  'latitude','longitude']
                          ).withColumn('latitude',col('latitude').cast('double')).withColumn('longitude',col('longitude').cast('double'))

# COMMAND ----------

store_df.write.format("delta").mode('overwrite').option("path", '/mnt/silver/delta/reference/store').saveAsTable('store')

# COMMAND ----------

# DBTITLE 1,store promotions
store_promotions_df = spark.createDataFrame([("abcde-j12345-e12345-f12345","30","Promotion"),
                                ("defgh-j12345-e12345-i12345","20","Promotion"),
                                ("jhijk-j12345-e12345-l12345","40","Promotion"),
                                ("lmnop-j12345-e12345-q12345","20","Promotion"),
                                ("mnopq-j12345-e12345-r12345","50","Promotion"),
                                ("pqrst-j12345-e12345-u12345","50","Promotion"),
                                ("rstuv-j12345-e12345-w12345","60","Promotion"),
                                ("tuvwx-j12345-e12345-y12345","25","Promotion"),
                                ],['StoreId','DiscountPercent','PromotionType']
                          )


store_promotions_df.write.format("delta").option("path", '/mnt/silver/delta/reference/storepromotions').saveAsTable('storepromotions')