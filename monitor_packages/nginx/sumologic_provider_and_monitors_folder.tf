# Sumo Logic Provider
provider "sumologic" {
  access_id   = "<SUMO_ACCESS_ID>"
  access_key  = "<SUMO_ACCESS_KEY>"
  environment = "<SUMO_ENVIRONMENT>"
}

#Sumo Logic Monitor Folder
resource "sumologic_monitor_folder" "tf_monitor_folder" {
  name = "Nginx"
  description = "Folder for Nginx Monitors"
}