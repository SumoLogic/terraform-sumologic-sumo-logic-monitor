# Sumo Logic Provider
provider "sumologic" {
  access_id   = var.access_id
  access_key  = var.access_key
  environment = var.environment
}

#Sumo Logic Monitor Folder
resource "sumologic_monitor_folder" "tf_monitor_folder_1" {
  name = var.folder
  description = "Folder for Couchbase Monitors"
}