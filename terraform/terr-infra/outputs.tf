output "vpc_network_id" {
  description = "ID of the created VPC network"
  value       = yandex_vpc_network.network.id
}

output "vpc_network_name" {
  description = "Name of the created VPC network"
  value       = yandex_vpc_network.network.name
}

output "vpc_network_folder_id" {
  description = "Folder ID where the VPC network is created"
  value       = yandex_vpc_network.network.folder_id
}

output "subnets_info" {
  description = "Information about the created subnets"
  value = {
    for subnet_key, subnet in yandex_vpc_subnet.subnet :
    subnet_key => {
      name           = subnet.name
      id             = subnet.id
      zone           = subnet.zone
      v4_cidr_blocks = subnet.v4_cidr_blocks
      network_id     = subnet.network_id
    }
  }
}
