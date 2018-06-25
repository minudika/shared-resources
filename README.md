

# Siddhi HTTP IO : File Download

This feature allows to download files using siddhi-io-http.
In order to handle response, you need to define multiple sources for each status code types.
For example, one source for 2xx status codes and another for 4xx ones.

### Instructions
In order to apply the newly added changes into WSO2 Stream Processor 4.1.0, please follow the steps given below.
 1. Shutdown  the server.
 2. Download **siddhi-io-http-1.0.18.jar** from this repository and replace the existing **siddhi-io-http-1.0.18.jar** in **WSO2SP-4.1.0**, which is located in **<SP_HOME>/lib** directory.
 3. Restart the server.

### Syntax

#### HTTP-Request Sink
You can use all the parameters supported by the ['http' sink](https://wso2-extensions.github.io/siddhi-io-http/api/1.0.18/#http-sink).
The URL of the file to be downloaded, should be provided as the publisher.url
In addition to those parameters, following new parameters have been introduced.
* **sink.id** :
This 'sink.id' is used to co-relate HTTP-Request sink and HTTP-Response source.
* **downloading.enabled** :
This parameter is to define whether the sink is used to download files.
* **download.path** :
This parameter is to define the path of that file to be downloaded.
This should  be the path that contains the name of the new file.
**eg : /home/downloads/downloaded_file.txt**

```sql
@sink(type="http-request", sink.id='<SINK_ID>',
downloading.enabled='<BOOLEAN'>,
method='GET',
publisher.url="<STRING>",
download.path = "<STRING>",
headers="<STRING>", method="<STRING>",
......
......
@map(...)))
```

#### HTTP-Response Source
* **sink.id** :
Http-response source captures the responses for the request sent by the http-request sink which has the same sink.id. You have to provide a sink.id when defining an http-response source, and there should be an http-request sink  with the same sink.id in the siddhi app.
* **http.status.code**
When download is enabled in a  sink, you have to define multiple sources to handle the responses with different status codes.  For a source, the accepting status code can be defined using 'http.status.code' parameter as following. The value for this parameter should be in 'N**' format where N is the first number of the status code.
The default value is **2**** .
***Eg : If the status code is 404,  it will go to the source with http.status.code='4**'***
```sql
@source(type='http-response', sink.id='<SINK_ID>', http.status.code='2**',
@map(...)))
```

### Example

```sql
@sink(type='http-request', downloading.enabled='true',
publisher.url='{{sourceFile}}', download.path='{{destination}}', method='GET',
headers='{{headers}}', sink.id='download-file',
@map(type='json'))
define stream requestStream (destination String, headers String, sourceFile string);

@source(type='http-response' , sink.id='download-file', http.status.code='2**',
@map(type='text', regex.A='((.|\n)*)', @attributes(fileName='A[1]')))
define stream responseStream2xx(fileName string);

@source(type='http-response' , sink.id='download-file', http.status.code='4**' ,
@map(type='text', regex.A='((.|\n)*)', @attributes(message='A[1]')))  
define stream responseStream4xx(message string);
```

In above example scenario,  the sink will send a **GET** request file that needs to be downloaded.

The server will send a response and the request is successful,  file will be downloaded to the path defined as the 'download.path' and the name  received to the stream of the http-response source with the **sink.id = 'download.file'** and http.status.code='**2****', in text format.

If the file is not found, the error message  will be received to the stream of http-response source with the http.status.code **4**** in  text format.

Text mapper has been configured to map the response messages correctly.

You can find a complete sample siddhi app [here](https://github.com/minudika/shared-resources/blob/file-download/DownloadFile.siddhi).
