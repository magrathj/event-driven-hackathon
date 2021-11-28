
# Event Driven Architecture with Databricks

## Entire Architecture
![image](https://user-images.githubusercontent.com/26692441/143684953-b1ee22e8-290d-4724-905e-c270835dd825.png)

## Event driven push notifications
![image](https://user-images.githubusercontent.com/26692441/143734815-9bfe09c8-308e-4f3f-a522-b2ee4c7647c8.png)

## Near Realtime Analytics capability
![image](https://user-images.githubusercontent.com/26692441/143735051-5423caa6-b835-4ed0-8a5c-269a4050b7d3.png)


### Event driven push notifications - Eventhub read/write with Databricks

To simulate multiple apps submitting events with GPS coordinates, we created a mock notebook to create the simulated data and push it to the eventhub. The main stream would then watch events coming from that eventhub and consume those events when they become available. It would then check if the gps coordinates are near a given store, and if so would add a promotion and write the results back to another eventhub. Following that downstream consumers could listen to those events and push a notification back to the app, allowing the end users to receive tailored promotions to their location. 

* Mock GPS data from app and write to eventhub consumer group **dev-readfrom**, in the mockgpsdata notebook
* Ingest GPS data from **dev-readfrom**, do transformation, write back to eventhub **dev-writeto** in the eventdrivenstreaming notebook

Mock gps data from multiple app users
![image](https://user-images.githubusercontent.com/26692441/143744711-c7454ccf-2b1e-4fb4-a80d-11add06c66e0.png)

Consume those events and write back those to the WriteTo eventhub, when those GPS coordinates are the proximity of a given store which has a promotion running
![image](https://user-images.githubusercontent.com/26692441/143741607-57a181c3-13f2-4959-8021-5c430de5f698.png)

Down stream apps can then listen to the promotion eventhub (WriteTo) and then forward push notifications. In this example, we could use logic apps to become a consumer of the eventhub **(for this PoC we left this out of scope but show how it could be done)**.
![image](https://user-images.githubusercontent.com/26692441/143750047-d3625f4b-db7a-4336-b20f-3e40989dac3d.png)


### Near Realtime Analytics capability

Events are stored into ADLS from the eventhubs into bronze. Here they have the avro schema format. The first thing we need to do is extract the body and get the raw data from there. Then we enrich the data by joining it onto the store dataset and promotions, so that we can provide a more rich dataset to provide analysis on. We then write the data to Silver. 
![image](https://user-images.githubusercontent.com/26692441/143751382-2f7ef225-089d-4975-9823-91833e61eb6f.png)


To provide an analytics layer we take the Silver data and aggregate it to useful information that our users would be interested in. We use spark streaming to ensure that we get near realtime tables that can provide our users with up to date information. 
![image](https://user-images.githubusercontent.com/26692441/143751179-d75aa3d1-09d1-4fb5-bd8a-86f9d18c5656.png)

When the analysis layer (GOLD) is ready, analyts can use it to query the results
![image](https://user-images.githubusercontent.com/26692441/143756781-1904d30c-8591-4540-a453-bfb757515f23.png)


### How to setup

clone repo
``` 
  git clone https://github.com/magrathj/event-driven-hackathon.git
```

cd into directory
``` 
  cd /event-driven-hackathon
```

#### Run workspace inside of dev container

Run the workspace inside of a remote container (in the .devcontainer folder) so that terraform is already install for you. 

You will need the remote container extension from VS code: https://code.visualstudio.com/docs/remote/containers

![image](https://user-images.githubusercontent.com/26692441/143688846-c243ddc7-96ac-427b-926d-94e7b0cfd278.png)


#### Deploy Azure environment (run locally)

##### Create service principal 

![image](https://user-images.githubusercontent.com/26692441/143719428-c87c19b6-85a3-4d9b-9889-2105fb90f9e1.png)

![image](https://user-images.githubusercontent.com/26692441/143719517-9daa9710-50c7-4037-b83a-f34ac414b26d.png)


cd into devops/environments/dev

```
 cd /devops/environments/dev
```

```
  terraform init
```

```
  terraform plan
```

#### Create containers in your lake 
![image](https://user-images.githubusercontent.com/26692441/143689302-2bf222f9-1571-4e37-9f4f-22277806f05b.png)


#### Create eventhubs
![image](https://user-images.githubusercontent.com/26692441/143689332-41819d3f-65f5-4bf1-8b41-099b09b3c672.png)

#### Turn on capture events
![image](https://user-images.githubusercontent.com/26692441/143689371-565e4965-b174-4b5c-836e-56e8441f0e6b.png)



#### Set up connection between databricks secret scope and key vault
![image](https://user-images.githubusercontent.com/26692441/143688624-d0a6a756-df6a-4ba7-a8be-a9f6fdfd7ec6.png)
![image](https://user-images.githubusercontent.com/26692441/143688635-8b722a56-d982-4c79-9851-e31a0939afdb.png)

#### Create the following secrets
![image](https://user-images.githubusercontent.com/26692441/143689542-66a60cb3-2583-4452-8363-f5b499773bb6.png)

#### Mount the workspace 

Run the following notebook to mount the workspace to your ADLS 
```
  /EventDrivenPromotions/mountlake
```

![image](https://user-images.githubusercontent.com/26692441/143689635-b3436407-e521-4602-b9f0-ba9f80cff5b4.png)


#### Create a logic app

![image](https://user-images.githubusercontent.com/26692441/143720320-8802cc2f-251a-4e2d-8cdc-4d7c7b6e175c.png)


## References:

Read/Write to eventhub 
https://docs.databricks.com/spark/latest/structured-streaming/streaming-event-hubs.html

Mock data to eventhub and read back
https://docs.microsoft.com/en-gb/azure/databricks/scenarios/databricks-stream-from-eventhubs

Connect keyvault to Azure Databricks
https://docs.microsoft.com/en-us/azure/databricks/security/secrets/secret-scopes

Run inside of dev container
https://code.visualstudio.com/docs/remote/containers

read in avro 
https://caiomsouza.medium.com/processing-event-hubs-capture-files-avro-format-using-spark-azure-databricks-save-to-parquet-95259001d85f
