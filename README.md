

# Siddhi HTTP IO : Request-Response

This feature allows users to send HTTP request using HTTP sink and receive the response for that request using an HTTP source and generate an event out of it.
In order to use this feature, you have to use the sink of type 'http-request' and a source of type 'http-response'.

### Instructions
In order to apply the newly added changes into WSO2 Stream Processor 4.1.0, please follow the steps given below.
 1. Shutdown  the server.
 2.  Download **siddhi-core_4.1.7.jar** from this repository and replace the existing **siddhi-core_4.1.7.jar** in **WSO2SP-4.1.0**.  You can find it in **<SP_HOME>/wso2/lib/plugins** directory.
 3. Download **siddhi-io-http-1.0.18.jar** from this repository and replace the existing **siddhi-io-http-1.0.18.jar** in **WSO2SP-4.1.0**, which is located in **<SP_HOME>/lib** directory.
 4. Restart the server.

### Syntax

#### HTTP-Request Sink
You can use all the parameters supported by the ['http' sink](https://wso2-extensions.github.io/siddhi-io-http/api/1.0.18/#http-sink).
In addition to those parameters, a new parameter called "**sink.id"**
This 'sink.id' is used to co-relate HTTP-Request sink and HTTP-Response source.
```sql
@sink(type="http-request", sink.id='<SINK_ID>', 
publisher.url="<STRING>", 
headers="<STRING>", method="<STRING>", 
......
......
@map(...)))
```

#### HTTP-Response Source
Http-response source captures the responses for the request sent by the http-request sink which has the same sink.id.
You have to provide a sink.id when defining an http-response source, and there should be an http-request sink  with the same sink.id in the siddhi app.

```sql
@source(type="http-response", sink.id='<SINK_ID>', 
@map(...)))
```

### Example

```sql
@sink(type='http-request', publisher.url='http://localhost:8080/company/',
method='POST', 
headers='{{headers}}', sink.id='reg-company-sink',
@map(type='json', @payload('{{payload}}')))
define stream BarStream (payload String, headers String);

@source(type='http-response' , sink.id='reg-company-sink',
@map(type='json')) 
define stream responseStream(name string, id int);
```

In above example scenario,  the sink will send a **POST** request to the endpoint 'http://localhost:8080/company/' with a body similar to the following.
```json
{"name":"wso2", "id":"123"}
```

The server will send a response like following and it will be received by http-response source with the sink.id =  reg-company-sink.
```json
{
	"event":
	{
		"name":"wso2", 
		"id": 1234
	}
}
```

Then it will be mapped to the attributes of **responseStream** using JSON default mapping.

Please find a complete sample siddhi app [here](https://github.com/minudika/shared-resources/blob/request-response/RequestResponseSample.siddhi).

