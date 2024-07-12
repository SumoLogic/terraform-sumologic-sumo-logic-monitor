module "IIS-SlowResponseTime" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "IIS - Slow Response Time"
  monitor_description         = "This alert fires when the response time for a given IIS server is greater than one second."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.iis_data_source} webserver_system=iis webserver_farm=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as iis_log_message | parse regex field=iis_log_message \"(?<server_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}) (?<method>\\S+?) (?<cs_uri_stem>\\S+?) (?<cs_uri_query>\\S+?) (?<s_port>\\S+?) (?<cs_username>\\S+?) (?<c_ip>\\S+?) (?<cs_User_Agent>\\S+?) (?<cs_referer>\\S+?) (?<sc_status>\\S+?) (?<sc_substatus>\\S+?) (?<sc_win32_status>\\S+?) (?<time_taken>\\S+?)$\" | if (isEmpty(pod),_sourceHost,pod) as host | where number(time_taken) > 1000 | fields server_ip,host,c_ip,cs_uri_query"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Warning",
				detection_method = "LogsStaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedWarning",
				detection_method = "LogsStaticCondition"
			  }
			]
}
module "IIS-ErrorEvents" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "IIS - Error Events"
  monitor_description         = "This alert fires when an error in the IIS logs is detected."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.iis_data_source} webserver_system=iis webserver_farm=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as iis_log_message | if (isEmpty(pod),_sourceHost,pod) as host | parse regex field=iis_log_message \"(?<datatime>\\d{1,4}-\\d{1,2}-\\d{1,2}\\s+\\d{1,2}:\\d{1,2}:\\d{1,2}) (?<c_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}) (?<c_port>\\S+?) (?<server_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}) (?<s_port>\\S+?) (?<protocol_version>\\S+?) (?<verb>\\S+?) (?<cookedurl_query>\\S+?) (?<Protocol_Status>\\S+?) (?<SiteId>\\S+?) (?<Reason_Phrase>\\S+?) (?<Queue_Name>\\S+?)\"  | fields c_ip,server_ip,host"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "LogsStaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "LogsStaticCondition"
			  }
			]
}
module "IIS-BlockedAsyncIORequests" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "IIS - Blocked Async IO Requests"
  monitor_description         = "This alert fires when we detect that there are blocked async I/O requests on an IIS server."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.iis_data_source} webserver_system=iis metric=win_websvc_Current_Blocked_Async_I_O_Requests webserver_farm=* host=* instance=* | sum by webserver_farm, host, instance"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "MetricsStaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "MetricsStaticCondition"
			  }
			]
}
module "IIS-HighServerHTTP5xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "IIS - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a 5xx response code."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.iis_data_source} webserver_system=iis webserver_farm=* 5* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as iis_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=iis_log_message \"(?<server_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}) (?<method>\\S+?) (?<cs_uri_stem>\\S+?) (?<cs_uri_query>\\S+?) (?<s_port>\\S+?) (?<cs_username>\\S+?) (?<c_ip>\\S+?) (?<cs_User_Agent>\\S+?) (?<cs_referer>\\S+?) (?<sc_status>\\S+?) (?<sc_substatus>\\S+?) (?<sc_win32_status>\\S+?) (?<time_taken>\\S+?)$\" | where sc_status matches \"5*\" or sc_status matches \"4*\" or sc_status matches \"3*\" or sc_status matches \"2*\" or sc_status matches \"1*\" | if (sc_status matches \"5*\", 1, 0) as server_error | sum(server_error) as ServerErrors, count as TotalRequests by Server | (ServerErrors / TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "LogsStaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "LogsStaticCondition"
			  }
			]
}
module "IIS-AccessfromHighlyMaliciousSources" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "IIS - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when an IIS server is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.iis_data_source} webserver_system=iis webserver_farm=* 5* \n| json \"log\" as _rawlog nodrop  \n| if (isEmpty(_rawlog), _raw, _rawlog) as iis_log_message \n| if (isEmpty(pod),_sourceHost,pod) as host \n| parse regex field=iis_log_message \"(?<server_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}) (?<method>\\S+?) (?<cs_uri_stem>\\S+?) (?<cs_uri_query>\\S+?) (?<s_port>\\S+?) (?<cs_username>\\S+?) (?<c_ip>\\S+?) (?<cs_User_Agent>\\S+?) (?<cs_referer>\\S+?) (?<sc_status>\\S+?) (?<sc_substatus>\\S+?) (?<sc_win32_status>\\S+?) (?<time_taken>\\S+?)$\" \n| threatlookup singleIndicator c_ip \n| where (_threatlookup.type=\"ipv4-addr:value\" or _threatlookup.type=\"ipv6-addr:value\") and !isNull(_threatlookup.confidence) \n| if (_threatlookup.confidence >= 85, \"high\", if (_threatlookup.confidence >= 50, \"medium\", if (_threatlookup.confidence >= 15, \"low\", if (_threatlookup.confidence >= 0, \"unverified\", \"Unknown\")))) as malicious_confidence \n| if (isEmpty(_threatlookup.actors), \"Unassigned\", _threatlookup.actors) as Actor \n| where malicious_confidence matches \"high\" \n| fields _threatlookup.fields, malicious_confidence, host,c_ip, Actor, iis_log_message"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "LogsStaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "LogsStaticCondition"
			  }
			]
}
module "IIS-ASPNETApplicationErrors" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "IIS - ASP.NET Application Errors"
  monitor_description         = "This alert fires when we detect an error in the ASP.NET applications running on an IIS server."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.iis_data_source} webserver_system=iis metric=win_aspnet_app_Errors_Total_persec objectname=\"asp.net applications\" webserver_farm=* host=* instance=* | sum by webserver_farm, host, instance"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "MetricsStaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "MetricsStaticCondition"
			  }
			]
}
module "IIS-HighClientHTTP4xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "IIS - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a 4xx response code."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.iis_data_source} webserver_system=iis webserver_farm=* 4* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as iis_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=iis_log_message \"(?<server_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}) (?<method>\\S+?) (?<cs_uri_stem>\\S+?) (?<cs_uri_query>\\S+?) (?<s_port>\\S+?) (?<cs_username>\\S+?) (?<c_ip>\\S+?) (?<cs_User_Agent>\\S+?) (?<cs_referer>\\S+?) (?<sc_status>\\S+?) (?<sc_substatus>\\S+?) (?<sc_win32_status>\\S+?) (?<time_taken>\\S+?)$\" | where sc_status matches \"5*\" or sc_status matches \"4*\" or sc_status matches \"3*\" or sc_status matches \"2*\" or sc_status matches \"1*\" | if (sc_status matches \"4*\", 1, 0) as client_error | sum(client_error) as client_error, count as TotalRequests by Server | (client_error/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, client_error, TotalRequests"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "LogsStaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "LogsStaticCondition"
			  }
			]
}
