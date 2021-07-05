module "ApacheTomcat-HighMemoryUsage" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache Tomcat - High Memory Usage"
  monitor_description         = "This alert fires when the memory usage is more than 80 %."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.apachetomcat_data_source} metric=tomcat_jmx_OperatingSystem_TotalPhysicalMemorySize webserver_farm=* host=* webserver_system=tomcat | eval _value/1024/1024 | sum by webserver_farm,host"
    B = "${var.apachetomcat_data_source} metric=tomcat_jmx_OperatingSystem_FreePhysicalMemorySize webserver_farm=* host=* webserver_system=tomcat | eval _value/1024/1024 | sum by webserver_farm,host"
    C = "(1 - (#B / #A)) * 100 along webserver_farm,host"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "ApacheTomcat-Error" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache Tomcat - Error"
  monitor_description         = "This alert fies when error count is greater than 0."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.apachetomcat_data_source} metric=tomcat_connector_error_count webserver_farm=* webserver_system=tomcat |sum by  host, webserver_farm"
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
module "ApacheTomcat-HighClient(HTTP4xx)ErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache Tomcat - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.apachetomcat_data_source} webserver_system=tomcat webserver_farm=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<user>\\S+)\\s+(?<hostname>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<user>\\S+)\\s+(?<hostname>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"\\s+\\d+\\s+[\\d-]+\\s+(?<timetaken>[\\d-]+)\" | if (status_code matches \"4*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
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
module "ApacheTomcat-HighServer(HTTP5xx)ErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache Tomcat - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.apachetomcat_data_source} webserver_system=tomcat webserver_farm=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<user>\\S+)\\s+(?<hostname>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<user>\\S+)\\s+(?<hostname>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"\\s+\\d+\\s+[\\d-]+\\s+(?<timetaken>[\\d-]+)\" | if (status_code matches \"5*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
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
module "ApacheTomcat-AccessfromHighlyMaliciousSources" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache Tomcat - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when a Tomcat server is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.apachetomcat_data_source} webserver_system=tomcat webserver_farm=* | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as _raw  | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<user>\\S+)\\s+(?<hostname>[\\S]+)\\s+\\[\" nodrop | parse regex \"(?<remote_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<local_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\\s+(?<user>\\S+)\\s+(?<hostname>[\\S]+)\\s+\\[\" nodrop | parse regex \"\\s+\\[(?<date>[^\\]]+)\\]\\s+\\\"(?<method>\\w+)\\s+(?<uri>\\S+)\\s+(?<protocol>\\S+)\\\"\\s+(?<status_code>\\d+)\\s+(?<size>[\\d-]+)\" nodrop | parse regex \"\\\"\\s+\\d+\\s+[\\d-]+\\s+(?<timetaken>[\\d-]+)\" | lookup type, actor, raw, threatlevel as Malicious_Confidence from sumo://threat/cs on threat=remote_ip  | where  type=\"ip_address\" and !isNull(Malicious_Confidence) | json field=raw \"labels[*].name\" as label_name  | replace(label_name, \"\\\\/\",\"->\") as label_name | replace(label_name, \"\\\"\",\" \") as label_name | if (isEmpty(actor), \"Unassigned\", actor) as Actor | where Malicious_Confidence matches \"high\" | fields raw,Malicious_Confidence,remote_ip, actor, _raw"
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
