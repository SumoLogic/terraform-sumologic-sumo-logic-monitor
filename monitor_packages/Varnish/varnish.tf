module "Varnish-High4XXErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - High 4XX Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} proxy_system=varnish proxy_cluster=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"(?<referrer>http[s]{0,1}:[^\\\"]+)\\\"\\s+\\\"(?<agent>[^\\\"]+?)\\\"\" | if (status_code matches \"4*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} proxy_system=varnish proxy_cluster=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"(?<referrer>http[s]{0,1}:[^\\\"]+)\\\"\\s+\\\"(?<agent>[^\\\"]+?)\\\"\" | lookup type, actor, raw, threatlevel as Malicious_Confidence from sumo://threat/cs on threat=remote_ip  | where  type=\"ip_address\" and !isNull(Malicious_Confidence) | json field=raw \"labels[*].name\" as label_name  | replace(label_name, \"\\\\/\",\"->\") as label_name | replace(label_name, \"\\\"\",\" \") as label_name | if (isEmpty(actor), \"Unassigned\", actor) as Actor | where Malicious_Confidence matches \"high\" | fields raw,Malicious_Confidence,remote_ip, actor, _raw"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_unhealthy proxy_system=varnish proxy_cluster=* host=* | sum by proxy_cluster,host"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} proxy_system=varnish proxy_cluster=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<client_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<logname>\\S+)\\s+(?<user>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"(?<referrer>http[s]{0,1}:[^\\\"]+)\\\"\\s+\\\"(?<agent>[^\\\"]+?)\\\"\" | if (status_code matches \"5*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_unhealthy proxy_system=varnish proxy_cluster=* host=* | sum by proxy_cluster,host "
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_fail proxy_cluster=* host=* | sum by proxy_cluster,host "
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
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} metric=varnish_backend_retry proxy_cluster=* host=* | sum by proxy_cluster,host"
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
module "Varnish-Threadcreationfailed" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Varnish - Thread creation failed"
  monitor_description         = "This alert fires when Varnish is unable to create threads, which indicates either under-provisioning or misconfiguration."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.varnish_data_source} metric=varnish_threads_failed proxy_cluster=* host=* | sum by proxy_cluster,host"
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
