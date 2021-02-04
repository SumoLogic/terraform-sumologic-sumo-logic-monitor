# Sumo Logic Provider
provider "sumologic" {
  access_id   = ""
  access_key  = ""
  environment = "us2"
}

#Sumo Logic Monitor Folder
resource "sumologic_monitor_folder" "tf_monitor_folder" {
  name = "Nginx"
  description = "Folder for Nginx Monitors"
}