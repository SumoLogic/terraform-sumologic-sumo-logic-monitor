# Sumo Logic Provider
provider "sumologic" {
  access_id   = "<SUMO_ACCESS_ID>"
  access_key  = "<SUMO_ACCESS_KEY>"
  environment = "<DEPLOYMENT>"
}

#Sumo Logic Monitor Folder
resource "sumologic_monitor_folder" "tf_monitor_folder_1" {
  name = "Terraform Managed Folder"
  description = "A folder for Monitors"
}