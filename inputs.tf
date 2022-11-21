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
variable "monitor_slo_type" {
  type        = string
  description = "The type of Slo, Sli or BurnRate. Required if Monitor Type is Slo."
  default     = null
}
variable "monitor_slo_id" {
  type        = string
  description = "Slo Id. Required if Monitor Type is Slo."
  default     = null
}
#variable "monitor_evaluation_delay" { . #TODO
#   type        = string
#   description = "Evaluation Delay."
#   default     = ""
# }
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
  type        = map
  description     = "All queries for the monitor."
  default     = null
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
  default = null
}

variable "slo_burnrate_triggers" {
  type        = list(object(
                {
                  threshold = number,
                  time_range = string,
                  trigger_type = string,
                }
    ))
  description = "Triggers for SLO Burn Rate alerting."
  default = null
}

variable "slo_sli_triggers" {
  type        = list(object(
                {
                  threshold = number,
                  trigger_type = string,
                }
    ))
  description = "Triggers for SLO Sli alerting."
  default = null
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