// Databricks notebook source
val keyVault = "dev-keyvault"

// COMMAND ----------

import scala.collection.JavaConverters._
import com.microsoft.azure.eventhubs._
import java.util.concurrent._
import scala.collection.immutable._
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

val namespaceName = dbutils.secrets.get(keyVault, "eventhub-namespace")
val eventHubName = dbutils.secrets.get(keyVault, "eventhub-name-readfrom")
val sasKeyName = dbutils.secrets.get(keyVault, "eventhub-sas-secret-name-readfrom")
val sasKey = dbutils.secrets.get(keyVault, "eventhub-sas-secret-key-readfrom") 
val connStr = new ConnectionStringBuilder()
            .setNamespaceName(namespaceName)
            .setEventHubName(eventHubName)
            .setSasKeyName(sasKeyName)
            .setSasKey(sasKey)

val pool = Executors.newScheduledThreadPool(1)
val eventHubClient = EventHubClient.createFromConnectionString(connStr.toString(), pool)

def sleep(time: Long): Unit = Thread.sleep(time)

def sendEvent(message: String, delay: Long) = {
  sleep(delay)
  val messageData = EventData.create(message.getBytes("UTF-8"))
  eventHubClient.get().send(messageData)
  System.out.println("Sent event: " + message + "\n")
}

// Simulating multiple users (appid) submitting gps coordinates
val testSource = List("latitude:51.1, longitude:0.1,appid:abcde-j12345-e12345-f12345",
"latitude:51.2, longitude:0.13,appid:abcde-j12345-e12345-g12345",
"latitude:51.3, longitude:0.16,appid:abcde-j12345-e12345-h12345",
"latitude:51.4, longitude:0.19,appid:abcde-j12345-e12345-i12345",
"latitude:51.5, longitude:0.22,appid:abcde-j12345-e12345-j12345",
"latitude:51.6, longitude:0.25,appid:abcde-j12345-e12345-k12345",
"latitude:51.7, longitude:0.28,appid:abcde-j12345-e12345-l12345",
"latitude:51.8, longitude:0.31,appid:abcde-j12345-e12345-m12345",
"latitude:51.9, longitude:0.34,appid:abcde-j12345-e12345-n12345",
"latitude:52, longitude:0.37,appid:abcde-j12345-e12345-g12345",
"latitude:52.1, longitude:0.4,appid:abcde-j12345-e12345-h12345",
"latitude:52.2, longitude:0.43,appid:abcde-j12345-e12345-i12345",
"latitude:52.3, longitude:0.46,appid:abcde-j12345-e12345-j12345",
"latitude:52.4, longitude:0.49,appid:abcde-j12345-e12345-k12345",
"latitude:52.5, longitude:0.52,appid:abcde-j12345-e12345-l12345",
"latitude:52.6, longitude:0.55,appid:abcde-j12345-e12345-m12345",
"latitude:52.7, longitude:0.58,appid:abcde-j12345-e12345-n12345",
"latitude:52.8, longitude:0.61,appid:abcde-j12345-e12345-g12345",
"latitude:52.9, longitude:0.64,appid:abcde-j12345-e12345-h12345",
"latitude:53, longitude:0.67,appid:abcde-j12345-e12345-i12345",
"latitude:53.1, longitude:0.7,appid:abcde-j12345-e12345-j12345",
"latitude:53.2, longitude:0.73,appid:abcde-j12345-e12345-k12345",
"latitude:53.3, longitude:0.76,appid:abcde-j12345-e12345-l12345",
"latitude:53.4, longitude:0.79,appid:abcde-j12345-e12345-m12345",
"latitude:53.5, longitude:0.82,appid:abcde-j12345-e12345-n12345",
"latitude:53.6, longitude:0.85,appid:abcde-j12345-e12345-g12345",
"latitude:53.7, longitude:0.88,appid:abcde-j12345-e12345-h12345",
"latitude:53.8, longitude:0.91,appid:abcde-j12345-e12345-i12345",
"latitude:53.9, longitude:0.94,appid:abcde-j12345-e12345-j12345",
"latitude:54, longitude:0.97,appid:abcde-j12345-e12345-k12345",
"latitude:54.1, longitude:1,appid:abcde-j12345-e12345-l12345",
"latitude:54.2, longitude:1.03,appid:abcde-j12345-e12345-m12345",
"latitude:54.3, longitude:1.06,appid:abcde-j12345-e12345-n12345",
"latitude:54.4, longitude:1.09,appid:abcde-j12345-e12345-g12345",
"latitude:54.5, longitude:1.12,appid:abcde-j12345-e12345-h12345",
"latitude:54.6, longitude:1.15,appid:abcde-j12345-e12345-i12345",
"latitude:54.7, longitude:1.18,appid:abcde-j12345-e12345-j12345",
"latitude:54.8, longitude:1.21,appid:abcde-j12345-e12345-k12345"
)

// Specify 'test' if you prefer to not use Twitter API and loop through a list of values you define in `testSource`
// Otherwise specify 'twitter'
val dataSource = "test"
val message = "latitude:1, longitude:1".toString()

if (dataSource == "test") {
  // Loop through the list of test input data
  while (true) {
    testSource.foreach {
      sendEvent(_,100)
    }
  }

} else {
  System.out.println("Unsupported Data Source. Set 'dataSource'  \"test\"")
}

// Closing connection to the Event Hub
eventHubClient.get().close()