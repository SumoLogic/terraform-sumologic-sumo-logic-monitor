# Sumo Logic
# Please replace <YOUR SUMO ACCESS ID> (including brackets) with your Sumo Access ID. https://help.sumologic.com/Manage/Security/Access-Keys
access_id           = "<YOUR SUMO ACCESS ID>"
# Please replace <YOUR SUMO ACCESS KEY> (including brackets) with your Sumo Access KEY.
access_key          = "<YOUR SUMO ACCESS KEY>"
# Please update with your deployment <DEPLOYMENT>, refer: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-and-Firewall-Security
environment         = "<DEPLOYMENT>"
# The Sumo Logic monitors will be installed in a folder specified by this value.
folder              = "Apache"
# This flag determines whether to enable all monitors or not.
monitors_disabled   = true
# Apache data source. Use this variable to narrow down the scope of alerts. e.g. for sending alerts for a specific webserver farm, apache_data_source = "webserver_farm=localapache", Leave blank to set scope to include all webserver farms.
apache_data_source = ""
