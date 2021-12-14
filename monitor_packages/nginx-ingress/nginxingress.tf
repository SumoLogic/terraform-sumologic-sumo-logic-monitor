module "NginxIngress-AccessfromHighlyMaliciousSources" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx Ingress - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when an Nginx Ingress server is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginxingress_data_source} webserver_system=nginx_ingress webserver_farm=* namespace=* deployment=* pod=* | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=nginx_log_message \"(?<ClientIp>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" | where ClientIp != \"0.0.0.0\" and ClientIp != \"127.0.0.1\" | count as ip_count by ClientIp, Server | lookup type, actor, raw, threatlevel as MaliciousConfidence from sumo://threat/cs on threat=ClientIp  | json field=raw \"labels[*].name\" as LabelName  | replace(LabelName, \"\\\\/\",\"->\") as LabelName | replace(LabelName, \"\\\"\",\" \") as LabelName | where type=\"ip_address\" and MaliciousConfidence=\"high\" | if (isEmpty(actor), \"Unassigned\", actor) as Actor | sum (ip_count) as ThreatCount by ClientIp, Server, MaliciousConfidence, Actor, LabelName"
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
module "NginxIngress-HighClientHTTP4xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx Ingress - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginxingress_data_source} webserver_system=nginx_ingress webserver_farm=* namespace=* deployment=* pod=* | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<StatusCode>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<UserAgent>.+?)\\\".*\" | if (StatusCode matches \"4*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
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
module "NginxIngress-HighServerHTTP5xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx Ingress - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginxingress_data_source} webserver_system=nginx_ingress webserver_farm=* namespace=* deployment=* pod=* | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<StatusCode>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<UserAgent>.+?)\\\".*\" | if (StatusCode matches \"5*\", 1, 0) as ServerError | sum(ServerError) as ServerErrors, count as TotalRequests by Server | (ServerErrors/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
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
module "NginxIngress-CriticalErrorMessages" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx Ingress - Critical Error Messages"
  monitor_description         = "This alert fires when we detect critical error messages for a given Nginx Ingress server."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "webserver_system=nginx_ingress webserver_farm=* namespace=* deployment=* pod=* | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=nginx_log_message \"\\s\\[(?<LogLevel>\\S+)\\]\\s\\d+#\\d+:\\s(?:\\*\\d+\\s|)(?<Message>[A-Za-z][^,]+)(?:,|$)\" | where LogLevel in (\"emerg\", \"alert\", \"crit\") | formatDate(_messageTime, \"MMM/dd/yyyy HH:mm:ss:SSS Z\") as MessageDate | count by MessageDate, Server, LogLevel, Message | fields MessageDate, Server, LogLevel, Message"
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
module "NginxIngress-DroppedConnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx Ingress - Dropped Connections"
  monitor_description         = "This alert fires when we detect dropped connections for a given Nginx Ingress server."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.nginxingress_data_source} metric = nginx_ingress_nginx_connections_handled webserver_system=nginx_ingress webserver_farm=* namespace=* deployment=* pod=* | sum by webserver_farm, deployment, namespace, pod"
    B = "${var.nginxingress_data_source} metric = nginx_ingress_nginx_connections_accepted webserver_system=nginx_ingress webserver_farm=* namespace=* deployment=* pod=* | sum by webserver_farm, deployment, namespace, pod"
    C = "#B - #A along webserver_farm, deployment, namespace, pod"
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
