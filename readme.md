
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



References:

Read/Write to eventhub 
https://docs.databricks.com/spark/latest/structured-streaming/streaming-event-hubs.html

Mock data to eventhub and read back
https://docs.microsoft.com/en-gb/azure/databricks/scenarios/databricks-stream-from-eventhubs

Connect keyvault to Azure Databricks
https://docs.microsoft.com/en-us/azure/databricks/security/secrets/secret-scopes

Run inside of dev container
https://code.visualstudio.com/docs/remote/containers
