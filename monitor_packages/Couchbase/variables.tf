variable "access_id" {
  type        = string
  description = "Sumo Logic Access ID. Visit https://help.sumologic.com/Manage/Security/Access-Keys#Create_an_access_key"
  validation {
    condition     = length(var.access_id) > 0
    error_message = "The \"sumo_access_id\" can not be empty."
  }
}
variable "access_key" {
  type        = string
  description = "Sumo Logic Access Key."
  validation {
    condition     = length(var.access_key) > 0
    error_message = "The \"sumo_access_key\" can not be empty."
  }
}
variable "environment" {
  type        = string
  description = "Please update with your deployment, refer: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-and-Firewall-Security"
  validation {
    condition = contains([
      "US1",
    "us1","US2","us2","AU","au","CA","ca","DE","de","EU","eu","FED","fed","JP","jp","IN","in"], var.environment)
    error_message = "Argument \"environment\" must be one of \"us1\",\"us2\",\"au\",\"ca\",\"de\",\"eu\",\"fed\",\"jp\",\"in\"."
  }
}
variable "folder" {
  type = string
  description = "Folder where monitors will be created."
  default = "Couchbase"
}

variable "monitors_disabled" {
  type = bool
  description = "Whether the monitors are enabled or not?"
  default = true
}

variable "connection_notifications_critical" {
  type        = list(object(
                {
                  connection_type = string,
                  connection_id = string,
                  payload_override = string,
                  run_for_trigger_types = list(string)
                }
    ))
  description = "Connection Notifications to be sent by the critical alert."
}

variable "connection_notifications_warning" {
  type        = list(object(
                {
                  connection_type = string,
                  connection_id = string,
                  payload_override = string,
                  run_for_trigger_types = list(string)
                }
    ))
  description = "Connection Notifications to be sent by the warning alert."
}

variable "connection_notifications_missingdata" {
  type        = list(object(
                {
                  connection_type = string,
                  connection_id = string,
                  payload_override = string,
                  run_for_trigger_types = list(string)
                }
    ))
  description = "Connection Notifications to be sent by the missingdata alert."
}

variable "email_notifications_critical" {
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
  description = "Email Notifications to be sent by the critical alert."
}

variable "email_notifications_critical" {
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
  description = "Email Notifications to be sent by the critical alert."
}

variable "email_notifications_warning" {
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
  description = "Email Notifications to be sent by the warning alert."
}

variable "email_notifications_missingdata" {
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
  description = "Email Notifications to be sent by the missingdata alert."
}

variable "group_notifications" {
  type        = bool
  description = "Whether or not to group notifications for individual items that meet the trigger condition. Defaults to true."
  default     = true
}
variable "couchbase_data_source" {
  type = string
  description = "Sumo Logic Couchbase Clusters Filter. For eg: db_cluster=couchbase.prod.01"
}