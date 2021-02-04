# Sumo Logic Provider
provider "sumologic" {
  access_id   = "sucx0wOuAvgFOa"
  access_key  = "ggCmhvDFM7oQmYsU7vR2ct5iYzkVV6NtP8BIYzZuYHr4XtAaFiBu6HJBJxmJDAn2"
  environment = "us2"
}

#Sumo Logic Monitor Folder
resource "sumologic_monitor_folder" "tf_monitor_folder" {
  name = "Nginx"
  description = "Folder for Nginx Monitors"
}