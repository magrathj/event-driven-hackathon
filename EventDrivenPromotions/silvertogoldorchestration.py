# Databricks notebook source
from pyspark.sql.functions import *
from pyspark.sql.types import *

# COMMAND ----------

input_path =  '/mnt/silver/delta/gps_points_near_stores'
output_path = "/mnt/gold/delta/aggregated_trips"

# COMMAND ----------

silverData = (spark.readStream
                .format("delta")
                .load(input_path)
             )

# COMMAND ----------

silverDataAggregate = (silverData
                       .groupBy("Location", "Merchant")
                       .count()
                      )

# COMMAND ----------

display(silverDataAggregate)

# COMMAND ----------

query = (silverDataAggregate
    .writeStream
    .format("delta")
    .outputMode("complete")
    .option("checkpointLocation", "/checkpoint/aggregate_trips/")
    .option("path", output_path)
    .table('gold.aggregated_trips')
    
)

# COMMAND ----------

