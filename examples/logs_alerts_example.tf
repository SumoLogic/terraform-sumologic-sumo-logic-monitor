# Sumo Logic Logs Monitors Example
module "sumologic-logs-monitor" {
  source                    = "SumoLogic/sumo-logic-monitor/sumologic"
  #version                  = "{revision}"
  monitor_name                = "Logs Monitor"
  monitor_description         = "Sample Logs Monitor"
  monitor_monitor_type        = "Logs"
  monitor_parent_id           = sumologic_monitor_folder.tf_monitor_folder_1.id

  # Queries - Only one query is allowed for Logs monitor
  queries = {
    A = "<Logs Query>"
  }

  # Triggers
  triggers = [
              {
                  threshold_type = "GreaterThanOrEqual",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "ResultCount", # Options: ResultCount and MissingData for logs
                  trigger_source = "AllResults", # Options: AllResults for logs.
                  trigger_type = "Critical",
                  detection_method = "StaticCondition"
                },
                {
                  threshold_type = "LessThan",
                  threshold = 0,
                  time_range = "5m",
                  occurrence_type = "ResultCount", # Options: ResultCount and MissingData for logs
                  trigger_source = "AllResults", # Options: AllResults for logs.
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