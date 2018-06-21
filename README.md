
# Siddhi HTTP IO : Request-Response

This feature allows to send HTTP request using HTTP sink and receive the response for that request uing a HTTP source and generate an event out of it.
In order to use this feature, you have to use the sink of type 'http-request' and a source of type 'http-response'.

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
You have to provide a sink.id when defining a http-response source, and there should be a http-request sink  with the same sink.id in the siddhi app.

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
		"id", 1234
	}
}
```

Then it will be mapped to the attributes of **responseStream** using JSON default mapping.


