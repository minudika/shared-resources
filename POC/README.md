# DEMO
 
## Instructions
Please note that these artifacts are working with WSO2SP-4.2.0.  Therefore please use a 4.2.0 pack in order to run this demo.

In order to apply the newly added changes into WSO2 Stream Processor 4.2.0,   follow the steps given below.
 1. Shutdown  the server.
 2. Download all the jars given in the **lib** directory and replace the existing ones in **<SP_HOME>/lib** directory with them.
 3. Download all the jars given in the **plugins** directory and replace the existing ones in **<SP_HOME>/wso2/lib/plugins** directory with them.
 4.  Add the bundle .jar of the relavent DB driver to the  **<SP_HOME>/lib directory**.
 5. Make sure the relavent data sources which are used in the siddhi app, have been defined in the deployment.yaml.
 6. Restart the server.



