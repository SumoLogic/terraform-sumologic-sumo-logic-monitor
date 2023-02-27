# Sumo Logic
# Please replace <YOUR SUMO ACCESS ID> (including brackets) with your Sumo Access ID. https://help.sumologic.com/Manage/Security/Access-Keys
access_id           = "<YOUR SUMO ACCESS ID>"
# Please replace <YOUR SUMO ACCESS KEY> (including brackets) with your Sumo Access KEY.
access_key          = "<YOUR SUMO ACCESS KEY>"
# Please update with your deployment, refer: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-and-Firewall-Security
environment         = "<DEPLOYMENT>"
# Please replace <YOUR SUMO ORGANIZATION ID> (including brackets) with your Sumo Organization ID.
sumologic_organization_id ="<YOUR SUMO ORGANIZATION ID>"
# The Sumo Logic monitors will be installed in a folder specified by this value.
folder = "NginxPlus"
# This flag determines whether to enable all monitors or not.
monitors_disabled = true
# This is the nginx plus metric data source in sumo logic.
metric_data_source = ""
# This is the nginx plus logs data source in sumo logic
logs_data_source = ""
group_notifications = true
connection_notifications = []
email_notifications = []