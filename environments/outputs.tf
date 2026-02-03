output "hub_vnet_id" {
  value = module.hub.vnet_id
}

output "web_spoke_id" {
  value = module.spoke_web.vnet_id
}

output "api_spoke_id" {
  value = module.spoke_api.vnet_id
}

output "key_vault_uri" {
  value = module.kv_web.kv_uri
}