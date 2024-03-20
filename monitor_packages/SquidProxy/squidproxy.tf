module "SquidProxy-HighLatency" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Squid Proxy - High Latency"
  monitor_description         = "This alert fires when latency on a node in a Squid Proxy cluster is higher than 3 seconds."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.squidproxy_data_source} metric=squid_cacheProtoClientHttpRequests proxy_cluster=* host=*  | rate | avg by proxy_cluster,host"
    B = "${var.squidproxy_data_source} metric=squid_cacheHttpAllSvcTime1 proxy_cluster=* host=* | avg by proxy_cluster,host | eval _value/60"
    C = "(#B/#A)/1000 along proxy_cluster,host"
  }
  triggers = [
			  {
				threshold_type = "GreaterThanOrEqual",
				threshold = 3,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "Critical",
				detection_method = "MetricsStaticCondition"
			  },
			  {
				threshold_type = "LessThan",
				threshold = 3,
				time_range = "5m",
				occurrence_type = "Always"
				trigger_source = "AnyTimeSeries"
				trigger_type = "ResolvedCritical",
				detection_method = "MetricsStaticCondition"
			  }
			]
}
module "SquidProxy-HighClientHTTP4xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Squid Proxy - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.squidproxy_data_source} proxy_system=squidproxy | json \"log\" as message nodrop  | if (isEMpty(message), _raw, message) as message | if (isEmpty(pod),_sourceHost,pod) as host | parse regex field = message \"(?<time>[\\d.]+)\\s+(?<elapsed>[\\d]+)\\s+(?<remotehost>[^\\s]+)\\s+(?<action>[^/]+)/(?<status_code>[\\d]+)\\s+(?<bytes>[\\d]+)\\s+(?<method>[^\\s]+)\\s+(?<url>[^\\s]+)\\s(?<rfc931>[^\\s]+)\\s+(?<peerstatus>[^/]+)/(?<peerhost>[^\\s]+)\\s+(?<type>[^\\s|$]+?)(?:\\s+|$)\" nodrop | parse field = message \"Connection: *\\\\r\\\\n\" as connection_status nodrop | parse field = message \"Host: *\\\\r\\\\n\" as host nodrop | parse field = message \"User-Agent: *\\\\r\\\\n\" as user_agent nodrop | parse field = message \"TE: *\\\\r\\\\n\" as te nodrop | if (status_code matches \"4*\",1,0) as ClientError |sum(ClientError) as ClientErrors, count as TotalRequests by host | (ClientErrors/TotalRequests) * 100 as ErrorPercentage |  where ErrorPercentage > 5 | fields host, ErrorPercentage, ClientErrors, TotalRequests"
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
module "SquidProxy-HighServerHTTP5xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Squid Proxy - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.squidproxy_data_source} proxy_system=squidproxy | json \"log\" as message nodrop  | if (isEMpty(message), _raw, message) as message | if (isEmpty(pod),_sourceHost,pod) as host | parse regex field = message \"(?<time>[\\d.]+)\\s+(?<elapsed>[\\d]+)\\s+(?<remotehost>[^\\s]+)\\s+(?<action>[^/]+)/(?<status_code>[\\d]+)\\s+(?<bytes>[\\d]+)\\s+(?<method>[^\\s]+)\\s+(?<url>[^\\s]+)\\s(?<rfc931>[^\\s]+)\\s+(?<peerstatus>[^/]+)/(?<peerhost>[^\\s]+)\\s+(?<type>[^\\s|$]+?)(?:\\s+|$)\" nodrop | parse field = message \"Connection: *\\\\r\\\\n\" as connection_status nodrop | parse field = message \"Host: *\\\\r\\\\n\" as host nodrop | parse field = message \"User-Agent: *\\\\r\\\\n\" as user_agent nodrop | parse field = message \"TE: *\\\\r\\\\n\" as te nodrop | if (status_code matches \"5*\",1,0) as ServerError |sum(ServerError) as ServerErrors, count as TotalRequests by host | (ServerErrors/TotalRequests) * 100 as ErrorPercentage |  where ErrorPercentage > 5 | fields host, ErrorPercentage, ServerErrors, TotalRequests"
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
module "SquidProxy-HighDeniedRequest" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Squid Proxy - High Denied Request"
  monitor_description         = "This alert fires when there are too many HTTP denied requests (>5%)"
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
  queries = {
    A = "${var.squidproxy_data_source} proxy_system=squidproxy | json \"log\" as message nodrop  | if (isEMpty(message), _raw, message) as message | if (isEmpty(pod),_sourceHost,pod) as host | parse regex field = message \"(?<time>[\\d.]+)\\s+(?<elapsed>[\\d]+)\\s+(?<remotehost>[^\\s]+)\\s+(?<action>[^/]+)/(?<status_code>[\\d]+)\\s+(?<bytes>[\\d]+)\\s+(?<method>[^\\s]+)\\s+(?<url>[^\\s]+)\\s(?<rfc931>[^\\s]+)\\s+(?<peerstatus>[^/]+)/(?<peerhost>[^\\s]+)\\s+(?<type>[^\\s|$]+?)(?:\\s+|$)\" nodrop | parse field = message \"Connection: *\\\\r\\\\n\" as connection_status nodrop | parse field = message \"Host: *\\\\r\\\\n\" as host nodrop | parse field = message \"User-Agent: *\\\\r\\\\n\" as user_agent nodrop | parse field = message \"TE: *\\\\r\\\\n\" as te nodrop | if (action matches \"*DENIED*\",1,0) as Denied |sum(Denied) as CountDenies, count as TotalRequests by host | (CountDenies/TotalRequests) * 100 as DeniedPercentage |  where DeniedPercentage > 5 | fields host, DeniedPercentage, CountDenies, TotalRequests"
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
