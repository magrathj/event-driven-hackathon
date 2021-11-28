# Databricks notebook source
from pyspark.sql.functions import *
from pyspark.sql.types import *

# COMMAND ----------

input_path = "/mnt/bronze/dev-eventhub-namespace/dev-readfrom"
input_avro_path = f"{input_path}/*/*/*/*/*/*/*.avro"
output_path = '/mnt/silver/delta/gps_points_near_stores'

# COMMAND ----------

schema = spark.read.format("avro").load(input_avro_path).schema

# COMMAND ----------

rawData = (spark.readStream
            .format("avro")
            .schema(schema)
            .load(input_avro_path)
            .select(col("Body").cast("string"))
            .withColumn("body", split("body", ",")) 
            .withColumn("latitude", split(col("body").getItem(0), ":").getItem(1).cast("double"))
            .withColumn("longitude", split(col("body").getItem(1), ":").getItem(1).cast("double"))
            .drop("body")            
          )

# COMMAND ----------

storeData = spark.read.table("reference.store")

# COMMAND ----------

promotionsData = spark.read.table("reference.storepromotions")

# COMMAND ----------

gps_points_near_stores_df =  rawData.join(storeData, ['latitude', 'longitude'], 'inner').join(promotionsData, ['storeid'])

# COMMAND ----------

query = (gps_points_near_stores_df
         .writeStream
         .format("delta")
         .option("checkpointLocation", "/checkpoint/enriched_trips/")
         .option("path", output_path)
         .outputMode("append")
         .table('silver.gps_enriched')
        )

# COMMAND ----------

