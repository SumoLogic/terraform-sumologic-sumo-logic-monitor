module "Varnish-High4XXErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - High 4XX Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
  queries = {
    A = "${var.varnish_data_source} cache_system=varnish cache_cluster=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"(?<referrer>http[s]{0,1}:[^\\\"]+)\\\"\\s+\\\"(?<agent>[^\\\"]+?)\\\"\" | if (status_code matches \"4*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 5,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 5,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "Varnish-AccessfromHighlyMaliciousSources" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when Varnish is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
  queries = {
    A = "${var.varnish_data_source} cache_system=varnish cache_cluster=* \n| json \"log\" as _rawlog nodrop  \n| if (isEmpty(_rawlog), _raw, _rawlog) as _raw \n| parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop \n| parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop \n| parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop \n| parse regex \"\\\"(?<referrer>http[s]{0,1}:[^\\\"]+)\\\"\\s+\\\"(?<agent>[^\\\"]+?)\\\"\" \n| threatlookup singleIndicator remote_ip \n| where (_threatlookup.type=\"ipv4-addr:value\" or _threatlookup.type=\"ipv6-addr:value\") and !isNull(_threatlookup.confidence) \n| if (_threatlookup.confidence >= 85, \"high\", if (_threatlookup.confidence >= 50, \"medium\", if (_threatlookup.confidence >= 15, \"low\", if (_threatlookup.confidence >= 0, \"unverified\", \"Unknown\")))) as malicious_confidence \n| if (isEmpty(_threatlookup.actors), \"Unassigned\", _threatlookup.actors) as Actor \n| where malicious_confidence matches \"high\" \n| fields _threatlookup.fields,malicious_confidence,remote_ip, Actor"
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
module "Varnish-BackendBusy" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - Backend Busy"
  monitor_description         = "This alert fires when the Varnish backend is busy for more than 5 minutes and is unable to serve requests."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_unhealthy cache_system=varnish cache_cluster=* host=* | sum by cache_cluster,host"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
module "Varnish-High5XXErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - High 5XX Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
  queries = {
    A = "${var.varnish_data_source} cache_system=varnish cache_cluster=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"(?<referrer>http[s]{0,1}:[^\\\"]+)\\\"\\s+\\\"(?<agent>[^\\\"]+?)\\\"\" | if (status_code matches \"5*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 5,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 5,
				time_range = "5m",
				occurrence_type = "ResultCount"
				trigger_source = "AllResults"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "Varnish-UnhealthyBackend" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - Unhealthy Backend"
  monitor_description         = "This alert fires when we detect that a backend server is unhealthy for more than 5 minutes."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_critical
  email_notifications       = var.email_notifications_critical
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_unhealthy cache_system=varnish cache_cluster=* host=* | sum by cache_cluster,host "
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
module "Varnish-BackendFailedConnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - Backend Failed Connections"
  monitor_description         = "This alert fires when there are failed connections to the backend."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_fail cache_system=varnish cache_cluster=* host=* | sum by cache_cluster,host "
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
module "Varnish-BackendConnectionRetries" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - Backend Connection Retries"
  monitor_description         = "This alert fires when there a more than 5 backend connection retries which can indicate misconfiguration."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_retry cache_system=varnish cache_cluster=* host=* | sum by cache_cluster,host"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 5,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 5,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
module "Varnish-ThreadCreationFailed" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - Thread Creation Failed"
  monitor_description         = "This alert fires when Varnish is unable to create threads, which indicates either under-provisioning or misconfiguration."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications_warning
  email_notifications       = var.email_notifications_warning
  queries = {
    A = "${var.varnish_data_source} metric=varnish_threads_failed cache_system=varnish cache_cluster=* host=* | sum by cache_cluster,host"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
