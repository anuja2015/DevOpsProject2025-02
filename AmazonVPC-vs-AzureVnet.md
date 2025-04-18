| Feature | Amazon VPC | Azure Virtual Network (VNet) |
|---------|------------|------------------------------|
| Main Purpose | Isolated network in AWS | Isolated network in Azure|
| Subnet Support | Yes | Yes |
| Route Tables | Customizable | Customizable |
| Network ACLs | Yes | NSGs (Network Security Groups) |
| Internet Gateway | Yes | Internet Gateway (via default route) |
| NAT Gateway | Yes | Azure NAT Gateway / NAT rules |
|VPN / Peering | Yes | Yes (VNet Peering, VPN Gateway) |


| AWS Component | Azure Equivalent |
|---------------| -----------------|
| Internet Gateway | Default route to Internet |
| NAT Gateway | Azure NAT Gateway |
| Network ACLs | Network Security Groups (NSG) |
| VPC Peering | VNet Peering |
| Route Tables | Route Tables in VNet/Subnet |
| VPN Gateway | Azure VPN Gateway |

| Feature | AWS (Security Group) | Azure (NSG) |
|---------| ---------------------| ------------|
| Default assignment | ✅ Default SG assigned to all supported resources | ❌ No NSG assigned by default (except via Portal VM wizard) |
| Automatically created | ✅ Yes, per VPC | ⚠️ Only by Azure Portal VM flow |
| Scope of rules | Instance-level | Subnet-level and/or NIC-level |
| Stateful vs Stateless | Stateful | Also stateful |

