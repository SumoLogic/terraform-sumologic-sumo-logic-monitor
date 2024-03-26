# Sumo Logic Apache Log Monitors
module "Apache-AccessfromHighlyMaliciousSources" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache - Access from Highly Malicious Sources"
  monitor_description         = "This alert fires when an Apache is accessed from highly malicious IP addresses."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Only one query is allowed for Logs monitor
  queries = {
    A = "${var.apache_data_source} component=webserver webserver_system=apache webserver_farm=* HTTP\n| parse regex \"^(?<src_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" nodrop\n| parse regex field=mesg \"(?<method>[A-Z]+)\\s(?<url>\\S+)\\sHTTP\\/[\\d\\.]+[\\\\n]*\\\"\\s(?<status_code>\\d+)\\s(?<size>[\\d-]+)\" nodrop\n| parse regex field=mesg \"(?<method>[A-Z]+)\\s(?<url>\\S+)\\sHTTP\\/[\\d\\.]+[\\\\n]*\\\"\\s(?<status_code>\\d+)\\s(?<size>[\\d-]+)\\s\\\"(?<referrer>.*?)\\\"\\s\\\"(?<user_agent>.+?)\\\".*\" nodrop\n| count as ip_count by src_ip, webserver_farm\n| threatlookup singleIndicator src_ip\n| where (_threatlookup.type=\"ipv4-addr:value\" or _threatlookup.type=\"ipv6-addr:value\") and !isNull(_threatlookup.confidence)\n| if (_threatlookup.confidence >= 85, \"high\", if (_threatlookup.confidence >= 50, \"medium\", if (_threatlookup.confidence >= 15, \"low\", if (_threatlookup.confidence >= 0, \"unverified\", \"Unknown\")))) as malicious_confidence\n| if (isEmpty(_threatlookup.actors), \"Unassigned\", _threatlookup.actors) as Actor\n| sum (ip_count) as threat_count by webserver_farm, malicious_confidence\n| where threat_count > 0 and tolowercase(malicious_confidence) = \"high\""
  }

  # Triggers
  triggers = [
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 0,
                  threshold_type = "GreaterThan",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 0,
                  threshold_type = "LessThanOrEqual",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

# Sumo Logic Apache Log Monitors
module "Apache-CriticalErrorMessages" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache - Critical Error Messages"
  monitor_description         = "This alert fires when we detect critical error messages for a given Apache server."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Only one query is allowed for Logs monitor
  queries = {
    A = "${var.apache_data_source} component=webserver webserver_system=apache webserver_farm=* AND (\"emerg\" OR \"alert\" OR \"crit\") \n| json \"log\" nodrop | if (_raw matches \"{*\", log, _raw) as mesg\n| parse regex field=mesg \" \\[(?<log_level>[a-z]+)\\] \" nodrop \n| parse regex field=mesg \" \\[(?<module>[a-z-]+):(?<log_level>[a-z]+)\\] \" nodrop \n| where log_level in (\"emerg\", \"alert\", \"crit\")\n| count by webserver_system, webserver_farm, log_level, mesg"
  }

  # Triggers
  triggers = [
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 0,
                  threshold_type = "GreaterThan",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 0,
                  threshold_type = "LessThanOrEqual",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

# Sumo Logic Apache Log Monitors
module "Apache-HighClientHTTP4xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache - High Client (HTTP 4xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 4xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Only one query is allowed for Logs monitor
  queries = {
    A = "${var.apache_data_source} component=webserver webserver_system=apache webserver_farm=* HTTP\n| parse regex \"^(?<src_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" nodrop\n| parse regex field=mesg \"(?<method>[A-Z]+)\\s(?<url>\\S+)\\sHTTP\\/[\\d\\.]+[\\\\n]*\\\"\\s(?<status_code>\\d+)\\s(?<size>[\\d-]+)\" nodrop\n| parse regex field=mesg \"(?<method>[A-Z]+)\\s(?<url>\\S+)\\sHTTP\\/[\\d\\.]+[\\\\n]*\\\"\\s(?<status_code>\\d+)\\s(?<size>[\\d-]+)\\s\\\"(?<referrer>.*?)\\\"\\s\\\"(?<user_agent>.+?)\\\".*\" nodrop\n| where status_code matches \"5*\" or status_code matches \"4*\" or status_code matches \"3*\" or status_code matches \"2*\" or status_code matches \"1*\"\n| if (status_code matches \"4*\", 1, 0) as client_error\n| count as hits, sum(client_error) as client_errors by webserver_farm\n| (client_errors / hits) * 100 as client_error_percent\n| where client_error_percent > 5"
  }

  # Triggers
  triggers = [
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 0,
                  threshold_type = "GreaterThan",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 0,
                  threshold_type = "LessThanOrEqual",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

# Sumo Logic Apache Log Monitors
module "Apache-HighServerHTTP5xxErrorRate" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache - High Server (HTTP 5xx) Error Rate"
  monitor_description         = "This alert fires when there are too many HTTP requests (>5%) with a response status of 5xx."
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Only one query is allowed for Logs monitor
  queries = {
    A = "${var.apache_data_source} component=webserver webserver_system=apache webserver_farm=* HTTP\n| parse regex \"^(?<src_ip>\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})\" nodrop\n| parse regex field=mesg \"(?<method>[A-Z]+)\\s(?<url>\\S+)\\sHTTP\\/[\\d\\.]+[\\\\n]*\\\"\\s(?<status_code>\\d+)\\s(?<size>[\\d-]+)\" nodrop\n| parse regex field=mesg \"(?<method>[A-Z]+)\\s(?<url>\\S+)\\sHTTP\\/[\\d\\.]+[\\\\n]*\\\"\\s(?<status_code>\\d+)\\s(?<size>[\\d-]+)\\s\\\"(?<referrer>.*?)\\\"\\s\\\"(?<user_agent>.+?)\\\".*\" nodrop\n| where status_code matches \"5*\" or status_code matches \"4*\" or status_code matches \"3*\" or status_code matches \"2*\" or status_code matches \"1*\"\n| if (status_code matches \"5*\", 1, 0) as server_error\n| count as hits, sum(server_error) as server_errors by webserver_farm\n| (server_errors / hits) * 100 as server_error_percent\n| where server_error_percent > 5"
  }

  # Triggers
  triggers = [
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 0,
                  threshold_type = "GreaterThan",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 0,
                  threshold_type = "LessThanOrEqual",
                  occurrence_type = "ResultCount",
                  trigger_source = "AllResults"
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

# Sumo Logic Apache Metric Monitors
module "Apache-HighCPUUtilization" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache - High CPU Utilization"
  monitor_description         = "This alert fires when the average CPU utilization within a 5 minute interval for an Apache Webserver farm instance is high (>=85%)."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.apache_data_source} webserver_system=apache metric=apache_CPUSystem webserver_farm=* server=* port=* host=* | avg by webserver_farm, server, port, host"
  }

  # Triggers
  triggers = [
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 85,
                  threshold_type = "GreaterThanOrEqual",
                  occurrence_type = "Always", # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger  
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 85,
                  threshold_type = "LessThan",
                  occurrence_type = "Always",
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}

# Sumo Logic Apache Metric Monitors
module "Apache-ServerRestarted" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Apache - Server Restarted"
  monitor_description         = "This alert fires when we detect low uptime (<= 10 minutes) for a given Apache server within a 5 minute interval."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "${var.apache_data_source} webserver_system=apache metric=apache_uptime webserver_farm=* server=* port=* host=* | filter latest < 600 | avg by webserver_farm, server, port, host"
  }

  # Triggers
  triggers = [
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "Critical",
                  threshold = 600,
                  threshold_type = "LessThanOrEqual",
                  occurrence_type = "Always", # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger  
                },
                {
                  detection_method = "StaticCondition",
                  time_range = "5m",
                  trigger_type = "ResolvedCritical",
                  threshold = 600,
                  threshold_type = "GreaterThan",
                  occurrence_type = "Always",
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                }
            ]

  # Notifications
  group_notifications       = var.group_notifications
  connection_notifications  = var.connection_notifications
  email_notifications       = var.email_notifications
}
