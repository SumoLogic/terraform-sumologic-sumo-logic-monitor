group_notifications = true
connection_notifications_critical = []
connection_notifications_warning = []
connection_notifications_missingdata = []
email_notifications_critical = []
email_notifications_warning = []
email_notifications_missingdata = []

# connection_notifications_critical = [{
#   connection_type       = "PagerDuty",
#   connection_id         = "<CONNECTION_ID>",
#   payload_override      = "{\"service_key\": \"your_pagerduty_api_integration_key\",\"event_type\": \"trigger\",\"description\": \"Alert: Triggered {{TriggerType}} for Monitor {{Name}}\",\"client\": \"Sumo Logic\",\"client_url\": \"{{QueryUrl}}\"}",
#   run_for_trigger_types = ["Critical", "ResolvedCritical"]
# },
# {
#   connection_type       = "Webhook",
#   connection_id         = "<CONNECTION_ID>",
#   payload_override      = "",
#   run_for_trigger_types = ["Critical", "ResolvedCritical"]
# }]
# email_notifications_critical = [{
#   connection_type       = "Email",
#   recipients            = ["abc@example.com"],
#   subject               = "Monitor Alert: {{TriggerType}} on {{Name}}",
#   time_zone             = "PST",
#   message_body          = "Triggered {{TriggerType}} Alert on {{Name}}: {{QueryURL}}",
#   run_for_trigger_types = ["Critical", "ResolvedCritical"]
# }]
