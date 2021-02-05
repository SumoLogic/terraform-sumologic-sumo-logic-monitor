# Sumo Logic Provider
provider "sumologic" {
  access_id   = "<SUMO_ACCESS_ID>"
  access_key  = "<SUMO_ACCESS_KEY>"
  environment = "<SUMO_ENVIRONMENT>"
}

#Sumo Logic Monitor Folder
resource "sumologic_monitor_folder" "tf_monitor_folder" {
  name = var.alerts_folder_name
  description = "Folder for Nginx Monitors"
}