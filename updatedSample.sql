create temporary table DAS_API_ResponseSummaryData2 using CarbonJDBC options (dataSource "WSO2AM_STATS_DB", tableName "DASHB_API_RESPONSE_SUMMARY_LAST_LAST_LAST",
    schema "api STRING, 
    api_version STRING,
    apiPublisher STRING,
    applicationName STRING,
    context STRING, 
    resourcePath STRING,
    method STRING,
    maxServiceTime INTEGER ,
    minServiceTime INTEGER ,
    serviceTime INTEGER ,
    maxBackendTime INTEGER ,
    minBackendTime INTEGER ,
    backendTime INTEGER ,
    total_response_count INTEGER ,
    hostName STRING ,
    year INTEGER ,
    month INTEGER ,
    day INTEGER,
    time STRING,
    resourceTemplate STRING",
    primaryKeys "api,api_version,apiPublisher,context,resourcePath,resourceTemplate,hostName,year,month,day"
                 
);

create temporary table DAS_APIMGT_PERHOUR_RESPONSE_DATA USING CarbonAnalytics OPTIONS(tableName 
	"ORG_WSO2_APIMGT_STATISTICS_PERMINUTERESPONSE", schema "
    year INT, month INT, day INT, hour INT, context STRING, api_version STRING, api STRING, resourceTemplate STRING, resourcePath STRING, version STRING, tenantDomain STRING, hostName STRING, apiPublisher STRING,
    destination STRING, consumerKey STRING, resourceTemplate STRING, method STRING, response INT, responseTime LONG, serviceTime LONG,backendTime LONG, username STRING, eventTime LONG, 
    applicationName STRING, applicationId STRING, cacheHit BOOLEAN, responseSize LONG, protocol STRING, responseCode INT,
    total_response_count LONG",
    primaryKeys "year, month, day, context, api_version, resourceTemplate, hostName, apiPublisher, destination, consumerKey, method, username");
       
      insert overwrite table DAS_API_ResponseSummaryData2 select
        api,
    	substring_index(api_version, '--', -1) as api_version,
    	apiPublisher,
    	applicationName,
    	context,
    	substring(resourcePath,0,49) as resourcePath,
    	method,
    	max(responseTime) as maxServiceTime,
    	min(responseTime) as minServiceTime,
    	avg(responseTime) as serviceTime, 
    	max(backendTime) as maxbackendTime,
    	min(backendTime) as minbackendTime,
    	avg(backendTime) as backendTime,
    	sum(total_response_count) as total_response_count,
    	hostName,
    	substring(cast(first(eventTime)/1000 as timestamp),0,4) as year,
    	substring(cast(first(eventTime)/1000 as timestamp),6,2) as month,
    	substring(cast(first(eventTime)/1000 as timestamp),9,2) as day,
    	substring(cast(first(eventTime)/1000 as timestamp),0,16) as time,
    	resourceTemplate
    from DAS_APIMGT_PERHOUR_RESPONSE_DATA
    where context is not NULL
    group by api,api_version,apiPublisher,context,resourcePath,applicationName,method,hostName,year,month,day,hour,resourceTemplate;
 
   
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                                                  
                            
                            
                            
                            
                            
                            
                            
