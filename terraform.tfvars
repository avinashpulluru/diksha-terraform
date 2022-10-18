resource_group_name = "diksha-terraform"
location            = "EAST US"
cluster_name        = "devops-coach-aks"
kubernetes_version  = "1.22.6"
system_node_count   = 1
acr_name            = "estacrakspoc"
kubernetes_cluster_node_pool = ["api1"]
