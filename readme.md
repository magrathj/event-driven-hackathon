
# Event Driven Architecture with Databricks

![image](https://user-images.githubusercontent.com/26692441/143684953-b1ee22e8-290d-4724-905e-c270835dd825.png)

## Eventhub read/write with Databricks

* Mock GPS data from app and write to eventhub consumer group **dev-readfrom**
* Ingest GPS data from **dev-readfrom**, do transformation, write back to eventhub **dev-writeto**

## How to setup

clone repo
``` 
  git clone https://github.com/magrathj/event-driven-hackathon.git
```

cd into directory
``` 
  cd /event-driven-hackathon
```

### Run workspace inside of dev container

Run the workspace inside of a remote container (in the .devcontainer folder) so that terraform is already install for you. 

You will need the remote container extension from VS code: https://code.visualstudio.com/docs/remote/containers

![image](https://user-images.githubusercontent.com/26692441/143688846-c243ddc7-96ac-427b-926d-94e7b0cfd278.png)


### Deploy Azure environment (run locally)

## Create service principal 

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

### Create containers in your lake 
![image](https://user-images.githubusercontent.com/26692441/143689302-2bf222f9-1571-4e37-9f4f-22277806f05b.png)


### Create eventhubs
![image](https://user-images.githubusercontent.com/26692441/143689332-41819d3f-65f5-4bf1-8b41-099b09b3c672.png)

### Turn on capture events
![image](https://user-images.githubusercontent.com/26692441/143689371-565e4965-b174-4b5c-836e-56e8441f0e6b.png)



### Set up connection between databricks secret scope and key vault
![image](https://user-images.githubusercontent.com/26692441/143688624-d0a6a756-df6a-4ba7-a8be-a9f6fdfd7ec6.png)
![image](https://user-images.githubusercontent.com/26692441/143688635-8b722a56-d982-4c79-9851-e31a0939afdb.png)

### Create the following secrets
![image](https://user-images.githubusercontent.com/26692441/143689542-66a60cb3-2583-4452-8363-f5b499773bb6.png)

### Mount the workspace 

Run the following notebook to mount the workspace to your ADLS 
```
  /EventDrivenPromotions/mountlake
```

![image](https://user-images.githubusercontent.com/26692441/143689635-b3436407-e521-4602-b9f0-ba9f80cff5b4.png)


### Create a logic app

![image](https://user-images.githubusercontent.com/26692441/143720320-8802cc2f-251a-4e2d-8cdc-4d7c7b6e175c.png)


References:

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
