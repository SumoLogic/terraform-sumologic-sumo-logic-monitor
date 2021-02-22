# Sumo Logic Nginx Metric Monitor
module "DroppedConnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Dropped Connections"
  monitor_description         = "This alert fires when we detect dropped connections for a given Nginx server."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.metric_data_source} metric = nginx_handled | sum by Server"
    B = "${var.metric_data_source} metric = nginx_accepts | sum by Server"
    C = "#B - #A along Server"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

# Sumo Logic Nginx Logs Monitor
module "AccessFromHighlyMaliciousSource" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when an Nginx is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  queries = {
    A = "${var.logs_data_source} \n| json auto maxdepth 1 nodrop\n| if (isEmpty(log), _raw, log) as nginx_log_message\n| _sourceHost as Server\n| parse regex field=nginx_log_message \"(?<ClientIp>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\"\n| where ClientIp != \"0.0.0.0\" and ClientIp != \"127.0.0.1\"\n| count as ip_count by ClientIp, Server\n| lookup type, actor, raw, threatlevel as MaliciousConfidence from sumo://threat/cs on threat=ClientIp \n| json field=raw \"labels[*].name\" as LabelName \n| replace(LabelName, \"\\\\/\",\"->\") as LabelName\n| replace(LabelName, \"\\\"\",\" \") as LabelName\n| where type=\"ip_address\" and MaliciousConfidence=\"high\"\n| if (isEmpty(actor), \"Unassigned\", actor) as Actor\n| sum (ip_count) as ThreatCount by ClientIp, Server, MaliciousConfidence, Actor, LabelName"
  }

  # Triggers
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

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "CriticalErrorMessage" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Critical Error Messages"
  monitor_description         = "This alert fires when we detect critical error messages for a given Nginx server."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  queries = {
    A = "${var.logs_data_source} \n| json auto maxdepth 1 nodrop\n| if (isEmpty(log), _raw, log) as nginx_log_message\n| _sourceHost as Server\n| parse regex field=nginx_log_message \"\\s\\[(?<LogLevel>\\S+)\\]\\s\\d+#\\d+:\\s(?:\\*\\d+\\s|)(?<Message>[A-Za-z][^,]+)(?:,|$)\"\n| where LogLevel in (\"emerg\", \"alert\", \"crit\")\n| formatDate(_messageTime, \"MMM/dd/yyyy HH:mm:ss:SSS Z\") as MessageDate\n| count by MessageDate, Server, LogLevel, Message\n| fields MessageDate, Server, LogLevel, Message"
  }

  # Triggers
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

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "HighClientError" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  queries = {
    A = "${var.logs_data_source} \n| json auto maxdepth 1 nodrop\n| if (isEmpty(log), _raw, log) as nginx_log_message\n| _sourceHost as Server\n| parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<StatusCode>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<UserAgent>.+?)\\\".*\"\n| if (StatusCode matches \"4*\", 1, 0) as ServerError\n| sum(ServerError) as ServerErrors, count as TotalRequests by Server\n| (ServerErrors/TotalRequests) * 100 as ErrorPercentage\n| where ErrorPercentage > 5\n| fields Server, ErrorPercentage, ServerErrors, TotalRequests"
  }

  # Triggers
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
                  occurrence_type = "ResultCount" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AllResults" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

module "HighServerError" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.logs_data_source} \n| json auto maxdepth 1 nodrop\n| if (isEmpty(log), _raw, log) as nginx_log_message\n| _sourceHost as Server\n| parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<StatusCode>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<UserAgent>.+?)\\\".*\"\n| if (StatusCode matches \"5*\", 1, 0) as ServerError\n| sum(ServerError) as ServerErrors, count as TotalRequests by Server\n| (ServerErrors/TotalRequests) * 100 as ErrorPercentage\n| where ErrorPercentage > 5\n| fields Server, ErrorPercentage, ServerErrors, TotalRequests"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "ResultCount" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AllResults" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "ResultCount" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AllResults" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}