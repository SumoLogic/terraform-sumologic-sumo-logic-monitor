# Sumo Logic http_response Metric Monitors

# check failed status
module "http_response-failed_check" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "http_response - Failed HTTP Check"
  monitor_description         = "This alert is fired if an HTTP synthetic check reports status other than success."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = <<EOF
    ${var.http_response_filter} 
    component=http_response metric=http_response_result_code not result=success 
    | count by server 
  EOF
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


# 4xx response code
module "http_response-4XX" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "http_response - Failed HTTP 4XX Code"
  monitor_description         = "This alert is fired if an HTTP synthetic check reports an HTTP 4XX code."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = <<EOF
    ${var.http_response_filter} 
    component=http_response metric=http_response_result_code status_code=4*
    | count by server 
  EOF
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

# 5xx response code
module "http_response-5XX" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "http_response - Failed HTTP 5XX Code"
  monitor_description         = "This alert is fired if an HTTP synthetic check reports an HTTP 5XX code."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = <<EOF
    ${var.http_response_filter} 
    component=http_response metric=http_response_result_code status_code=4*
    | count by server 
  EOF
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


# high average response time
module "http_response-high_response_time" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "http_response - High Page Response Time"
  monitor_description         = "This alert is fired if an HTTP synthetic check reports high response time."
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id
  monitor_is_disabled         = var.monitors_disabled

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = <<EOF
    ${var.http_response_filter} 
    component=http_response metric=http_response_response_time  
    | avg  by server
  EOF
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThan",
                  threshold = 10,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThanOrEqual",
                  threshold = 10,
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
