# Sumo Logic Nginx Metric Monitor
module "DroppedConnections" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Dropped Connections"
  monitor_description         = "This alert fires when we detect that the number of dropped connections is greater than 0 for 5 minutes."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.nginx_metric_data_source} metric = nginx_handled | sum by Server"
    B = "${var.nginx_metric_data_source} metric = nginx_accepts | sum by Server"
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
module "AccessFromMaliciousSource" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Access from Malicious Source"
  monitor_description         = "This alert fires when we detect that the number of Access Logs with Malicious Source (Client IP) is greater than 0 for 5 minutes."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.nginx_logs_data_source} | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | parse regex field=nginx_log_message \"(?<Client_Ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" | lookup type, actor, raw, threatlevel as Malicious_Confidence from sumo://threat/cs on threat=Client_Ip | where type=\"ip_address\" and !isNull(Malicious_Confidence)"
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

module "CriticalErrorMessage" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - Critical Error Messages"
  monitor_description         = "This alert fires when we detect that the number of Critical Error Messages is greater than 0 for 5 minutes."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.nginx_logs_data_source} | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | parse regex field=nginx_log_message \"\\s\\[(?<Log_Level>\\S+)\\]\\s\\d+#\\d+:\\s(?:\\*\\d+\\s|)(?<Message>[A-Za-z][^,]+)(?:,|$)\" | where log_level in (\"emerg\", \"alert\", \"crit\")"
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

module "HighClientError" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Nginx - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx within an interval of 5 minutes."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.nginx_logs_data_source} | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | parse regex field=nginx_log_message \"(?<Client_Ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" | parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<Status_Code>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<User_Agent>.+?)\\\".*\" | if (Status_Code matches \"4*\", 1, 0) as Server_Error | sum(Server_Error) as Server_Error, count as Total_Requets | (Server_Error/Total_Requets) * 100 as Percent | fields Percent"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "ResultCount" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AllResults" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 5,
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
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx within an interval of 5 minutes."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.nginx_logs_data_source} | json auto maxdepth 1 nodrop | if (isEmpty(log), _raw, log) as nginx_log_message | parse regex field=nginx_log_message \"(?<Client_Ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" | parse regex field=nginx_log_message \"(?<Method>[A-Z]+)\\s(?<URL>\\S+)\\sHTTP/[\\d\\.]+\\\"\\s(?<Status_Code>\\d+)\\s(?<Size>[\\d-]+)\\s\\\"(?<Referrer>.*?)\\\"\\s\\\"(?<User_Agent>.+?)\\\".*\" | if (Status_Code matches \"5*\", 1, 0) as Server_Error | sum(Server_Error) as Server_Error, count as Total_Requets | (Server_Error/Total_Requets) * 100 as Percent | fields Percent"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 5,
                  time_range = "5m",
                  occurrence_type = "ResultCount" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AllResults" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 5,
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