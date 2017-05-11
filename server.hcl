# Set datacenter name
datacenter = "dc1"

# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/var/run/nomad/data"

# Force addresses
addresses {
  http = "IPADDR"
  rpc  = "IPADDR"
  serf = "IPADDR"
}

# Enable the server
server {
  enabled          = true
  bootstrap_expect = 3
}

