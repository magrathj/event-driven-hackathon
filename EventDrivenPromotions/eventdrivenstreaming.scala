// Databricks notebook source
val keyVault = "dev-keyVault"

// COMMAND ----------

import org.apache.spark.eventhubs.{ ConnectionStringBuilder, EventHubsConf, EventPosition }
import org.apache.spark.sql.functions.{ explode, split, concat, lit, current_timestamp }

// To connect to an Event Hub, EntityPath is required as part of the connection string.
// Here, we assume that the connection string from the Azure portal does not have the EntityPath part.
val connectionString = dbutils.secrets.get(keyVault,"evenhub-connection-readfrom")
val readFromEventHub = dbutils.secrets.get(keyVault,"eventhub-name-readfrom")
ConnectionStringBuilder(connectionString)
  .setEventHubName("dev-readfrom")
  .build
val eventHubsConf = EventHubsConf(connectionString)
  .setStartingPosition(EventPosition.fromEndOfStream)
  
val eventhubs = spark.readStream
  .format("eventhubs")
  .options(eventHubsConf.toMap)
  .load()

// COMMAND ----------

// split lines by whitespaces and explode the array as rows of 'word'
val df = eventhubs.select(explode(split($"body".cast("string"), "\\s+")).as("word"))
  .groupBy($"word")
  .count

// COMMAND ----------

// follow the word counts as it updates
display(df.select($"word", $"count"))

// COMMAND ----------

// DBTITLE 1,Extract Data from event Hubs Input data
import org.apache.spark.eventhubs.{ ConnectionStringBuilder, EventHubsConf, EventPosition }
import org.apache.spark.sql.streaming.Trigger.ProcessingTime

val connectionString = dbutils.secrets.get(keyVault,"eventhub-connection-writeback")
val writeBackEventHub = dbutils.secrets.get(keyVault,"eventhub-name-writeback")

val connString = ConnectionStringBuilder(connectionString)
  .setEventHubName("dev-writeback")
  .build
val eventHubsConfWrite = EventHubsConf(connString)


val source = 
  eventhubs
    .withColumnRenamed("value", "body")
    .select($"Body".cast("string"))
    .withColumn("body", split($"body", ",")) 
    .withColumn("latitude", split($"body".getItem(0), ":").getItem(1).cast("double"))
    .withColumn("longitude", split($"body".getItem(1), ":").getItem(1).cast("double"))
    .withColumn("appid", split($"body".getItem(2), ":").getItem(1).cast("string"))
    .drop("body")  




// COMMAND ----------

// DBTITLE 1,Write Back Aggregated Data to EventHub
val store = spark.read.table("reference.store").withColumnRenamed("latitude","storelatitude").withColumnRenamed("longitude","storelongitude")
val storepromotions = spark.read.table("reference.storepromotions").withColumn("DiscountPercent",$"DiscountPercent".cast("float"))

val query = source
    .join(store, source("latitude") === store("storelatitude") && source("longitude") === store("storelongitude"))
    .join(storepromotions, store("StoreId") === storepromotions("StoreId"))
    .groupBy($"latitude",$"longitude",$"Location",$"appid")
    .sum("DiscountPercent")
    .withColumnRenamed("sum(DiscountPercent)","Discount")
    .withColumn("body",concat(lit("latitude: "),$"latitude", lit(", longitude: "), $"longitude", lit(", Location: "),$"Location",lit(", Discount:"),$"Discount", lit(", AppId:"),$"appid"))
    .select($"body" cast "string")
    .writeStream
    .format("eventhubs")
    .outputMode("update")
    .options(eventHubsConfWrite.toMap)
    .option("checkpointLocation", "/checkpoint/eventhubwrite/")
    .start()