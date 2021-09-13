module "HAProxy-HighServerConnectionErrors" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - High Server Connection Errors"
  monitor_description         = "There are too many connection errors to backend servers."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} metric=haproxy_econ type=server proxy_cluster=* proxy_system=haproxy | sum by proxy_cluster, host, proxy"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 100,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 100,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
module "HAProxy-FrontendSecurityBlockedRequests" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Frontend Security Blocked Requests"
  monitor_description         = "HAProxy is blocking requests for security reasons"
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} metric=haproxy_dcon type=frontend proxy_system=haproxy proxy_cluster=* host=* | sum by proxy_cluster, host, proxy|  rate"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 10,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 10,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
module "HAProxy-RetryHigh" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Retry High"
  monitor_description         = "There is a high retry rate"
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} metric=haproxy_wretr type=backend proxy_cluster=* host=* proxy_system=haproxy | sum by proxy_cluster,host,proxy "
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
module "HAProxy-AccessfromHighlyMaliciousSources" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when an HAProxy is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} proxy_cluster = * proxy_system=haproxy | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as haproxy_log_message | parse regex field=haproxy_log_message \"(?<syslog_host>.*)\\]:\\s+\" nodrop | parse regex field=haproxy_log_message \":\\s+(?<c_ip>[\\w\\.]+):(?<c_port>\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\[(?<accept_date>.+)\\]\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\[(?<accept_date>.+)\\]\\s+(?<frontend_name>\\S+)\\s+(?<backend_name>\\S+)/(?<server_name>\\S+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<tq>-?\\d+)/(?<tw>-?\\d+)/(?<tc>-?\\d+)/(?<tr>-?\\d+)/(?<tt>\\+?\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<status_code>\\d+)\\s+(?<bytes_read>[\\d-]+)\\s+(?<tsc>.*)\\s+(?<act>\\d+)/(?<fe>\\d+)/(?<be>\\d+)/(?<srv>\\d+)/(?<retries>\\+?\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<queue_server>\\d+)/(?<queue_backend>\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\{(?<request_headers>.*)\\}\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\\"(?<http_request>.*)\\\"\" nodrop | parse regex field=request_headers \"(?<referer>\\S+)\\|(?<user_agent>[^\\\"]*)\" | parse regex field=http_request \"(?<method>\\w+)\\s+(?<request>[^\\\"]*)\\s+(?<http_version>\\w+)\" | lookup type, actor, raw, threatlevel as Malicious_Confidence from sumo://threat/cs on threat=c_ip  | where  type=\"ip_address\" and !isNull(Malicious_Confidence) | json field=raw \"labels[*].name\" as label_name  | replace(label_name, \"\\\\/\",\"->\") as label_name | replace(label_name, \"\\\"\",\" \") as label_name | if (isEmpty(actor), \"Unassigned\", actor) as Actor | where Malicious_Confidence matches \"high\" | fields raw,Malicious_Confidence,c_ip, actor, haproxy_log_message"
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
module "HAProxy-HighActiveBackendServerSessions" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - High Active Backend Server Sessions"
  monitor_description         = "When the percent of backend server connections are high."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    B = "${var.haproxy_data_source} metric=haproxy_slim type=server proxy_cluster=* proxy_system=haproxy | sum by proxy_cluster, host"
    C = "${var.haproxy_data_source} metric=haproxy_smax type=server proxy_cluster=* proxy_system=haproxy | sum by proxy_cluster, host"
    D = "100*#C/#B"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 80,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
module "HAProxy-HighClientHTTP4xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} proxy_cluster = * proxy_system=haproxy | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as haproxy_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=haproxy_log_message \"(?<syslog_host>.*)\\]:\\s+\" nodrop | parse regex field=haproxy_log_message \":\\s+(?<c_ip>[\\w\\.]+):(?<c_port>\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\[(?<accept_date>.+)\\]\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\[(?<accept_date>.+)\\]\\s+(?<frontend_name>\\S+)\\s+(?<backend_name>\\S+)/(?<server_name>\\S+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<tq>-?\\d+)/(?<tw>-?\\d+)/(?<tc>-?\\d+)/(?<tr>-?\\d+)/(?<tt>\\+?\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<status_code>\\d+)\\s+(?<bytes_read>[\\d-]+)\\s+(?<tsc>.*)\\s+(?<act>\\d+)/(?<fe>\\d+)/(?<be>\\d+)/(?<srv>\\d+)/(?<retries>\\+?\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<queue_server>\\d+)/(?<queue_backend>\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\{(?<request_headers>.*)\\}\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\\"(?<http_request>.*)\\\"\" nodrop | parse regex field=request_headers \"(?<referer>\\S+)\\|(?<user_agent>[^\\\"]*)\" | parse regex field=http_request \"(?<method>\\w+)\\s+(?<request>[^\\\"]*)\\s+(?<http_version>\\w+)\" | where status_code matches \"5*\" or status_code matches \"4*\" or status_code matches \"3*\" or status_code matches \"2*\" or status_code matches \"1*\" | if (status_code matches \"4*\", 1, 0) as client_error | sum(client_error) as client_error, count as TotalRequests by Server | (client_error/TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, client_error, TotalRequests"
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
module "HAProxy-SlowResponseTime" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Slow Response Time"
  monitor_description         = "The HAProxy response times are greater than one second."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} metric=haproxy_ctime_max type=server proxy_cluster=* | avg by proxy_cluster,host,proxy"
  }
  triggers = [
			  {
				threshold_type = "GreaterThan",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Warning",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 1,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedWarning",
				detection_method = "StaticCondition"
			  }
			]
}
module "HAProxy-HighServerHTTP5xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} proxy_cluster = * proxy_system=haproxy | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as haproxy_log_message | if (isEmpty(pod),_sourceHost,pod) as Server | parse regex field=haproxy_log_message \"(?<syslog_host>.*)\\]:\\s+\" nodrop | parse regex field=haproxy_log_message \":\\s+(?<c_ip>[\\w\\.]+):(?<c_port>\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\[(?<accept_date>.+)\\]\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\[(?<accept_date>.+)\\]\\s+(?<frontend_name>\\S+)\\s+(?<backend_name>\\S+)/(?<server_name>\\S+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<tq>-?\\d+)/(?<tw>-?\\d+)/(?<tc>-?\\d+)/(?<tr>-?\\d+)/(?<tt>\\+?\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<status_code>\\d+)\\s+(?<bytes_read>[\\d-]+)\\s+(?<tsc>.*)\\s+(?<act>\\d+)/(?<fe>\\d+)/(?<be>\\d+)/(?<srv>\\d+)/(?<retries>\\+?\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+(?<queue_server>\\d+)/(?<queue_backend>\\d+)\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\{(?<request_headers>.*)\\}\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+\\\"(?<http_request>.*)\\\"\" nodrop | parse regex field=request_headers \"(?<referer>\\S+)\\|(?<user_agent>[^\\\"]*)\" | parse regex field=http_request \"(?<method>\\w+)\\s+(?<request>[^\\\"]*)\\s+(?<http_version>\\w+)\" | where status_code matches \"5*\" or status_code matches \"4*\" or status_code matches \"3*\" or status_code matches \"2*\" or status_code matches \"1*\" | if (status_code matches \"5*\", 1, 0) as server_error | sum(server_error) as ServerErrors, count as TotalRequests by Server | (ServerErrors / TotalRequests) * 100 as ErrorPercentage | where ErrorPercentage > 5 | fields Server, ErrorPercentage, ServerErrors, TotalRequests"
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
module "HAProxy-ServerHealthcheckFailure" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Server Healthcheck Failure"
  monitor_description         = "Server healthchecks are failing."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} metric=haproxy_chkfail type=server proxy_cluster=* proxy_system=haproxy "
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
module "HAProxy-BackendError" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Backend Error"
  monitor_description         = "This alert fires when we detect backend server errors."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} proxy_cluster=* proxy_system=haproxy backend | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as haproxy_log_message | parse regex field=haproxy_log_message \"(?<syslog_host>.*)\\]:\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+backend\\s+(?<frontend_name>\\S+)\\s+(?<msg>.*)\" nodrop | where length(frontend_name) > 0 | fields  proxy_cluster, frontend_name, msg"
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
module "HAProxy-PendingRequests" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Pending Requests"
  monitor_description         = "HAProxy requests are pending"
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} metric=haproxy_qcur type=backend proxy_cluster=* proxy_system=haproxy | rate"
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
module "HAProxy-HasNoAliveBackends" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Has No Alive Backends"
  monitor_description         = "HAProxy has no alive active or backup backend servers"
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} metric=haproxy_active_servers type=backend proxy_cluster=* host=* | sum by proxy_cluster, host, proxy"
    B = "${var.haproxy_data_source} metric=haproxy_backup_servers  type=backend proxy_cluster=* host=* | sum by proxy_cluster, host, proxy"
    C = "#A+#B along proxy_cluster, host, proxy"
  }
  triggers = [
			  {
				threshold_type = "LessThanOrEqual",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "StaticCondition"
			  },
			  {
				threshold_type = "GreaterThan",
				threshold = 0,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "StaticCondition"
			  }
			]
}
module "HAProxy-BackendServerDown" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "HAProxy - Backend Server Down"
  monitor_description         = "This alert fires when we detect a backend server for a given HAProxy server is down."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.haproxy_data_source} proxy_cluster=* proxy_system=haproxy Server | json \"log\" as _rawlog nodrop  | if (isEmpty(_rawlog), _raw, _rawlog) as haproxy_log_message | parse regex field=haproxy_log_message \"(?<syslog_host>.*)\\]:\\s+\" nodrop | parse regex field=haproxy_log_message \"\\s+Server\\s+(?<frontend_name>\\S+)/(?<backend_name>\\S+)\\s+is\\s+DOWN,\\s+reason:\\s+(?<reason>.*),\\s+info:\\s+\\\"(?<info>.*)\\\",\\s+check\\s+duration:\\s+(?<check_duration>\\d+)ms.\\s+(?<active>\\d+)\\s+active\\s+and\\s+(?<backup>\\d+)\\s+backup\\s+servers\\s+left.\\s+(?<sessions>\\d+) sessions\\s+active,\\s+(?<requeued>\\d+)\\s+requeued,\\s+(?<remaining>\\d+)\\s+remaining\\s+in\\s+queue.\" nodrop | where length(frontend_name) > 0 and length(backend_name) > 0 | fields proxy_cluster, frontend_name, backend_name, reason, info"
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
