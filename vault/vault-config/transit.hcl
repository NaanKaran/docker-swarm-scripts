storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

disable_mlock = true
ui = true

seal "transit" {
  address     = "http://vault:8200"
  token       = "<generated token from transit-script.sh>"
  key_name    = "autounseal"
  mount_path  = "transit/"
}
