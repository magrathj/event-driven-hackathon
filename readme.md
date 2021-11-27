

![image](https://user-images.githubusercontent.com/26692441/143684953-b1ee22e8-290d-4724-905e-c270835dd825.png)

### Event driven read/write 

* Mock GPS data from app and write to eventhub consumer group **dev-readfrom**
* Ingest GPS data from **dev-readfrom**, do transformation, write back to eventhub **dev-writeto**


Ref:

Read/Write to eventhub 
https://docs.databricks.com/spark/latest/structured-streaming/streaming-event-hubs.html

Mock data to eventhub and read back
https://docs.microsoft.com/en-gb/azure/databricks/scenarios/databricks-stream-from-eventhubs
