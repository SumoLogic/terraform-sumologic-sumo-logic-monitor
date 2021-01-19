# Sumo Logic Monitors
variable "monitor_name" {
  type        = string
  description = "Monitor Name"
}
variable "monitor_parent_id" {
  type        = string
  description = "The ID of the Monitor Folder that contains this monitor."
  default     = null
}
variable "monitor_description" {
  type        = string
  description = "The description of the monitor."
  default     = ""
}
variable "monitor_monitor_type" {
  type        = string
  description = "The type of monitor, Logs or Metrics. Default Logs"
  default     = "Logs"
}
variable "monitor_is_disabled" {
  type        = bool
  description = "Whether or not the monitor is disabled. Default false."
  default     = false
}
variable "group_notifications" {
  type        = bool
  description = "Whether or not to group notifications for individual items that meet the trigger condition. Defaults to true."
  default     = true
}

variable "queries" {
  type      = map
  description     = "All queries for the monitor."
}

variable "triggers" {
  type        = list(object(
                {
                  threshold_type = string,
                  threshold = number,
                  time_range = string,
                  occurrence_type = string,
                  trigger_source = string,
                  trigger_type = string,
                  detection_method = string
                }
    ))
  description = "Triggers for alerting."
}


variable "connection_notifications" {
  type        = list(object(
                {
                  connection_type = string,
                  connection_id = string,
                  payload_override = string,
                  run_for_trigger_types = list(string)
                }
    ))
  description = "Connection Notifications to be sent by the alert."
}

variable "email_notifications" {
  type        = list(object(
                {
                  connection_type = string,
                  recipients = list(string),
                  subject = string,
                  time_zone = string,
                  message_body = string,
                  run_for_trigger_types = list(string)
                }
    ))
  description = "Email Notifications to be sent by the alert."
}