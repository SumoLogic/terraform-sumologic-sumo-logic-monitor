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
variable "sumologic_organization_id" {
  type        = string
  description = <<EOT
            You can find your org on the Preferences page in the Sumo Logic UI. For more information, see the Preferences Page topic. For more details, visit https://help.sumologic.com/01Start-Here/05Customize-Your-Sumo-Logic-Experience/Preferences-Page
        EOT
  validation {
    condition     = can(regex("\\w+", var.sumologic_organization_id))
    error_message = "The organization ID must contain valid characters."
  }
}
variable "folder" {
  type = string
  description = "Folder where monitors will be created."
  default = "ApacheTomcat"
}

variable "monitors_disabled" {
  type = bool
  description = "Whether the monitors are enabled or not?"
  default = true
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

variable "group_notifications" {
  type        = bool
  description = "Whether or not to group notifications for individual items that meet the trigger condition. Defaults to true."
  default     = true
}
variable "apachetomcat_data_source" {
  type = string
  description = "Sumo Logic Apache Tomcat Farm Filter. For eg: webserver_farm=tomcat.prod.01"
}