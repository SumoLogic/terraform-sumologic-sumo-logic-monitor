resource "sumologic_monitor" "tf_monitor_1" {
  name = var.monitor_name
  parent_id  = var.monitor_parent_id
  description = var.monitor_description
  type = "MonitorsLibraryMonitor"
  is_disabled = var.monitor_is_disabled
  content_type = "Monitor"
  monitor_type = var.monitor_monitor_type
  group_notifications = var.group_notifications

  dynamic "queries" {
      for_each = var.queries
      content {
            row_id = queries.key
            query = queries.value
      }
  }

  dynamic "triggers" {
    for_each = var.triggers
    content {
            threshold_type = triggers.value.threshold_type
            threshold = triggers.value.threshold
            time_range = triggers.value.time_range
            occurrence_type = triggers.value.occurrence_type
            trigger_source = triggers.value.trigger_source
            trigger_type = triggers.value.trigger_type
            detection_method = triggers.value.detection_method
          }
  }

  dynamic "notifications" {
    for_each = var.connection_notifications
            content {
                run_for_trigger_types = notifications.value.run_for_trigger_types
              notification {
                connection_type = notifications.value.connection_type
                connection_id = notifications.value.connection_id
                payload_override = notifications.value.payload_override
            }
          }
  }

  dynamic "notifications" {
    for_each = var.email_notifications
            content {
                run_for_trigger_types = notifications.value.run_for_trigger_types
              notification {
                connection_type = notifications.value.connection_type
                recipients = notifications.value.recipients
                subject = notifications.value.subject
                time_zone = notifications.value.time_zone
                message_body = notifications.value.message_body
            }
          }
  }
}