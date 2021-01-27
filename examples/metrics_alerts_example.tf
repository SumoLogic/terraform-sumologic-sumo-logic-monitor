# Sumo Logic Metrics Monitors Example
module "sumologic-metrics-monitor" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Metrics Monitor"
  monitor_description         = "Sample Metrics Monitor"
  monitor_monitor_type        = "Metrics"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Multiple queries allowed for Metrics monitor
  queries = {
    A = "<Metric_query1>",
    B = "<Metric_query2>",
    C = "<Metric_query3>"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics. 'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "Always" # Options: Always, AtLeastOnce and MissingData for Metrics
                  trigger_source = "AnyTimeSeries" # Options: AllTimeSeries and AnyTimeSeries for Metrics.'AnyTimeSeries' is the only valid triggerSource for 'Critical' trigger
                  trigger_type = "ResolvedCritical",
                  detection_method = "StaticCondition"
                }
            ]

  # Notifications
  group_notifications       = true
  connection_notifications = [
    {
      connection_type = "PagerDuty",
      connection_id = "<CONNECTION_ID>",
      payload_override = "{\"service_key\": \"your_pagerduty_api_integration_key\",\"event_type\": \"trigger\",\"description\": \"Alert: Triggered {{TriggerType}} for Monitor {{Name}}\",\"client\": \"Sumo Logic\",\"client_url\": \"{{QueryUrl}}\"}",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    },
    {
      connection_type = "Webhook",
      connection_id = "<CONNECTION_ID>",
      payload_override = "",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    }
  ]
  email_notifications = [
    {
      connection_type = "Email",
      recipients = ["abc@example.com"],
      subject = "Monitor Alert: {{TriggerType}} on {{Name}}",
      time_zone = "PST",
      message_body = "Triggered {{TriggerType}} Alert on {{Name}}: {{QueryURL}}",
      run_for_trigger_types = ["Critical", "ResolvedCritical"]
    }
  ]
}