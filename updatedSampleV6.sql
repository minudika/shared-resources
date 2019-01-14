create temporary table DAS_API_ResponseSummaryData2 using CarbonJDBC options (dataSource "WSO2AM_STATS_DB", tableName "NEW_ANALYTICS_TABLE_2",
    schema "api STRING,
    api_version STRING,
    apiPublisher STRING,
    applicationName STRING,
    context STRING,
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
    hour INTEGER,
    time STRING,
    resourceTemplate STRING,
    primaryKeys "api,api_version,apiPublisher,context,resourceTemplate,applicationName,method,hostName,year,month,day,hour"
  );


CREATE TEMPORARY TABLE APIMGT_PERMINUTE_RESPONSE_DATA USING CarbonAnalytics OPTIONS(tableName "ORG_WSO2_APIMGT_STATISTICS_PERMINUTERESPONSE", schema "
    year INT, month INT, day INT, hour INT, minute INT,
    context STRING, api_version STRING, api STRING, resourceTemplate STRING, version STRING, tenantDomain STRING, hostName STRING, apiPublisher STRING,
    destination STRING, consumerKey STRING, resourcePath STRING, method STRING, response INT, responseTime LONG, serviceTime LONG, backendTime LONG,
    username STRING, eventTime LONG, applicationName STRING, applicationId STRING, cacheHit BOOLEAN, responseSize LONG, protocol STRING,
    responseCode INT, total_response_count LONG, _timestamp LONG",
    primaryKeys "year, month, day, hour, minute, context, api_version, resourceTemplate, hostName, apiPublisher, destination, consumerKey, method, username",
    incrementalParams "APIMGT_STATISTICS_PERMINUTERESPONSELATEST, HOUR",
    mergeSchema "false");

      insert into table DAS_API_ResponseSummaryData2 select
        api,
        substring_index(api_version, '--', -1) as api_version,
        apiPublisher,
        applicationName,
        context,
        method,
        max(responseTime) as maxServiceTime,
        min(responseTime) as minServiceTime,
        avg(responseTime) as serviceTime,
        max(backendTime) as maxbackendTime,
        min(backendTime) as minbackendTime,
        avg(backendTime) as backendTime,
        sum(total_response_count) as total_response_count,
        hostName,
        year,
        month,
        day,
        hour,
        substring(cast(first(eventTime)/1000 as timestamp),0,16) as time,
        resourceTemplate,
        substring(resourcePath,0,49) as resourcePath
    from APIMGT_PERMINUTE_RESPONSE_DATA
    where context is not NULL and applicationName is not NULL
    group by api,api_version,apiPublisher,context,applicationName,method,hostName,year,month,day,hour,resourceTemplate,resourcePath;


    INCREMENTAL_TABLE_COMMIT APIMGT_STATISTICS_PERMINUTERESPONSELATEST;
