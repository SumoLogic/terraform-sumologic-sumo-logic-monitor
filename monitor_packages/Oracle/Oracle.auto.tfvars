# Sumo Logic
# Please replace <YOUR SUMO ACCESS ID> (including brackets) with your Sumo Access ID. https://help.sumologic.com/Manage/Security/Access-Keys
access_id           = "<YOUR SUMO ACCESS ID>"
# Please replace <YOUR SUMO ACCESS KEY> (including brackets) with your Sumo Access KEY.
access_key          = "<YOUR SUMO ACCESS KEY>"
# Please update with your deployment, refer: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-and-Firewall-Security
environment         = "<DEPLOYMENT>"
# This flag determines whether to enable all monitors or not.
monitors_disabled   = true
# The Sumo Logic monitors will be installed in a folder specified by this value.
folder              = "Oracle"
# Sumo Logic Oracle Cluster Filter. For eg: db_cluster=oracle.prod.01
oracle_data_source = ""