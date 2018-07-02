# Siddhi : Support for multi-threading
This enables **configurable multi threading** in siddhi.

## Syntax

 Adding number of workers and maximum event batch size for processing.

```sql
@async(buffer.size='16', workers='2', batch.size.max='5')
define stream AStream (...);
```
If '**workers**' is not defined it will be defaulted to **1** and thedefault of '**batch.size.max**' is '**buffer.size**'.


## Instructions
In order to apply the newly added changes into WSO2 Stream Processor 4.1.0, please follow the steps given below.
 1. Shutdown  the server.
 2.  Download **siddhi-core_4.1.7.jar** from this repository and replace the existing **siddhi-core_4.1.7.jar** in **WSO2SP-4.1.0**.  You can find it in **<SP_HOME>/wso2/lib/plugins** directory.
 3. Restart the server.


