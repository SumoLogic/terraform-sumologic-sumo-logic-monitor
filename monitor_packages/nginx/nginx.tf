module "Nginx-CriticalErrorMessages" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Critical Error Messages"
  monitor_description         = "This alert fires when we detect critical error messages for a given Nginx server."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "webserver_system=nginx | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | parse regex field=nginx_log_message \"\\s\\[(?<LogLevel>\\S+)\\]\\s\\d+#\\d+:\\s(?:\\*\\d+\\s|)(?<Message>[A-Za-z][^,]+)(?:,|$)\" | where LogLevel in (\"emerg\", \"alert\", \"crit\") | if (isEmpty(pod),_sourceHost,pod) as host | formatDate(_messageTime, \"MMM/dd/yyyy HH:mm:ss:SSS Z\") as MessageDate | count by MessageDate, host, LogLevel, Message | fields MessageDate, host, LogLevel, Message"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "Nginx-HighClientHTTP4xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginx_data_source} webserver_system=nginx | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | if (isEmpty(pod),_sourceHost,pod) as host | parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<StatusCode>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<UserAgent>.+?)\\\".*\" | if (StatusCode matches \"4*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by host | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields host, ErrorPercentage, ServerErrors, TotalRequests"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "Nginx-HighServerHTTP5xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginx_data_source} webserver_system=nginx | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | if (isEmpty(pod),_sourceHost,pod) as host | parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<StatusCode>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<UserAgent>.+?)\\\".*\" | if (StatusCode matches \"5*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by host | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields host, ErrorPercentage, ServerErrors, TotalRequests"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "Nginx-DroppedConnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Dropped Connections"
  monitor_description         = "This alert fires when we detect dropped connections for a given Nginx server."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginx_data_source} webserver_system=nginx metric = nginx_handled webserver_farm=* host=* | sum by webserver_farm,host"
    B = "${var.nginx_data_source} webserver_system=nginx metric = nginx_accepts webserver_farm=* host=* | sum by webserver_farm,host"
    C = "#B - #A along webserver_farm,host"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "Nginx-AccessfromHighlyMaliciousSources" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when an Nginx server is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginx_data_source} webserver_system=nginx \n| json auto maxdepth 1 nodrop \n| if (isEmpty(log), _raw, log) as nginx_log_message \n| if (isEmpty(pod),_sourceHost,pod) as host \n| parse regex field=nginx_log_message \"(?<ClientIp>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" \n| where ClientIp != \"0.0.0.0\" and ClientIp != \"127.0.0.1\" \n| count as ip_count by ClientIp, host \n| threatlookup singleIndicator ClientIp \n| where (_threatlookup.type=\"ipv4-addr:value\" or _threatlookup.type=\"ipv6-addr:value\") and !isNull(_threatlookup.confidence) \n| if (_threatlookup.confidence >= 85, \"high\", if (_threatlookup.confidence >= 50, \"medium\", if (_threatlookup.confidence >= 15, \"low\", if (_threatlookup.confidence >= 0, \"unverified\", \"Unknown\")))) as malicious_confidence \n| if (isEmpty(_threatlookup.actors), \"Unassigned\", _threatlookup.actors) as Actor \n| where malicious_confidence=\"high\" \n| sum (ip_count) as ThreatCount by ClientIp, host, malicious_confidence, Actor"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
