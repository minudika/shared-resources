


# Connecting to IBM MQ

You can connect to IBM MQ using siddhi-io-jms extensions.

## Instructions
Follow the instructions below to build and install IBM MQ client JAR files to WSO2 SP.

These instructions are tested on IBM WebSphere MQ version 9.0.0.0.  However, you can follow them for other versions appropriately.

 1.    Create a new directory named `wmq-client`, and then create another new directory named `lib` inside it.
 2. Copy the following JAR files from the `<IBM_MQ_HOME>/java/lib/` directory (where `<IBM_MQ_HOME>` refers to the IBM WebSphere MQ installation directory) to the `wmq-client/lib/` directory.
	
	-   `com.ibm.mq.allclient.jar`
    
	-   `fscontext.jar`
    
	-   `jms.jar`
    
	-   `providerutil.jar`
3. Create a `POM.xml` file inside the wmq`-client/` directory and add all the required dependencies as shown in the example below. 

> Note : You need to change the values of the `<version>` and `<systemPath>` properties accordingly.

```xml
<?xml version="1.0"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
<modelVersion>4.0.0</modelVersion>
<groupId>wmq-client</groupId>
<artifactId>wmq-client</artifactId>
<version>9.0.0.0</version>
<packaging>bundle</packaging>
<dependencies>
    <dependency>
        <groupId>com.ibm</groupId>
        <artifactId>fscontext</artifactId>
        <version>9.0.0.0</version>
        <scope>system</scope>
        <systemPath>${basedir}/lib/fscontext.jar</systemPath>
    </dependency>
    <dependency>
        <groupId>com.ibm</groupId>
        <artifactId>providerutil</artifactId>
        <version>9.0.0.0</version>
        <scope>system</scope>
        <systemPath>${basedir}/lib/providerutil.jar</systemPath>
    </dependency>
    <dependency>
        <groupId>com.ibm</groupId>
        <artifactId>allclient</artifactId>
        <version>9.0.0.0</version>
        <scope>system</scope>
        <systemPath>${basedir}/lib/com.ibm.mq.allclient.jar</systemPath>
    </dependency>
    <dependency>
        <groupId>javax.jms</groupId>
        <artifactId>jms</artifactId>
        <version>1.1</version>
        <scope>system</scope>
        <systemPath>${basedir}/lib/jms.jar</systemPath>
    </dependency>
</dependencies>
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.felix</groupId>
            <artifactId>maven-bundle-plugin</artifactId>
            <version>2.3.4</version>
            <extensions>true</extensions>
            <configuration>
                <instructions>
                    <Bundle-SymbolicName>${project.artifactId}</Bundle-SymbolicName>
                    <Bundle-Name>${project.artifactId}</Bundle-Name>
                    <Export-Package>*;-split-package:=merge-first</Export-Package>
                    <Private-Package/>
                    <Import-Package/>
                    <Embed-Dependency>*;scope=system;inline=true</Embed-Dependency>
                    <DynamicImport-Package>*</DynamicImport-Package>
                </instructions>
            </configuration>
        </plugin>
    </plugins>
</build>
</project>
```
4. -   Navigate to the wmq`-client` directory using your Command Line Interface (CLI), and execute the following command, to build the project: mvn `clean install`
5. -   Stop the WSO2 SP server, if it is already running.
6. -   Remove any existing IBM MQ client JAR files from the `<WSO2SP_HOME>/lib`  directory .
7. -   Copy the `<wmq-client>/target/wmq-client-x.x.x.x.jar` file to the `<	WSO2SP_Home>/lib` directory.
		- Note : You can find wmq-client-9.0.0.0.jar which was tested with IBM MQ 9.0 in [here](https://github.com/minudika/shared-resources/blob/ibmmq-support/lib/client-libs/wmq-client-9.0.0.0.jar)

Also you need to register the InitialContextFactory implementation according to the OSGi JNDI spec. In order to do that, 

8. Navigate to {WSO2SPHome}/bin and run the following command. Provide privileges if necessary using chmod +x icf-provider (sh|bat).
              - For Linux:
                    `./icf-provider.sh com.sun.jndi.fscontext.RefFSContextFactory {IBM-MQ-HOME}/java/lib/fscontext.jar <Output Jar Path>`
                   - For Windows:
                    `./icf-provider.bat com.sun.jndi.fscontext.RefFSContextFactory {IBM-MQ-HOME}\java\lib\fscontext.jar <Output Jar Path>`

9.  If converted successfully then it will create 'fscontext' directory in the \<Output Jar Path\> directory, with OSGi converted and original jars:
              - fscontext.jar (Original Jar)
              - fscontext_1.0.0.jar (OSGi converted Jar)
Also, following messages would be shown on the terminal
```
    	      INFO: Executing 'jar uf <absolute_path>/fscontext.jar -C <absolute_path>/fscontext /internal/CustomBundleActivator.class'

              [timestamp] org.wso2.carbon.tools.spi.ICFProviderTool addBundleActivatorHeader

              INFO: Running jar to bundle conversion [timestamp] org.wso2.carbon.tools.converter.utils.BundleGeneratorUtils convertFromJarToBundle

              INFO: Created the OSGi bundle fscontext_1.0.0.jar for JAR file <absolute_path>/fscontext/fscontext.jar
```
10. You can find the osgi converted lib in 'fscontext' folder in \<Output Jar Path\> directory.  Copy 'fscontext/fscontext_1.0.0.jar' to {WSO2SP-Home}/lib.
	- Note : You can find fscontext_1.0.0.jar which was tested with IBM MQ 9.0 in [here](https://github.com/minudika/shared-resources/blob/ibmmq-support/lib/client-libs/fscontext_1.0.0.jar) 
11. Download [**org.wso2.carbon.jndi_1.0.5.jar**](https://github.com/minudika/shared-resources/blob/ibmmq-support/lib/plugins/org.wso2.carbon.jndi_1.0.5.jar) and copy it to {WSO2SP-HOME}/wso2/lib/plugins directory.
12. Re-start the server.

## Example

Following siddhi app will consume JSON messages from an IBM message queue named "myQueue" and converted them to  siddhi-events using JSON mapping.

```sql
@App:name('IbmMq')
@App:description('Receive events via JMS provider from an IBM Message queue in JSON format with default mapping and view the output on the console.')

@source(type='jms',
factory.initial='com.sun.jndi.fscontext.RefFSContextFactory',
provider.url='file:/home/user/binding/',
destination='myQueue',
connection.factory.type='queue',
connection.factory.jndi.name='MyConnectionFactory',
connection.username = 'username',
connection.password = 'password',
@map(type='json'))
define stream SweetProductionStream(name string, amount double);

@sink(type='log')
define stream LowProductionAlertStream(name string, amount double);

@info(name='EventsPassthroughQuery')
from SweetProductionStream
select *
insert into LowProductionAlertStream;
```

The expected message format is following.
```json
{"event":
	{
		"name":"chocolate",
		"amount":123.45
	}
}
```

You can find this sample siddhi app [here](https://github.com/minudika/shared-resources/blob/ibmmq-support/IbmMq.siddhi)

