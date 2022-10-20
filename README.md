# env0 Application Example Code

Welcome! This code is meant to explore some of the features of the env0 platform and accompanies [this YouTube video](https://youtu.be/rhGc27VHASk). In order to follow along, you will need to meet some prerequisites.

## Prerequisites for running

The demo makes use of GitHub, Microsoft Azure, and env0. You will need the following resources in each platform to get started.

* **GitHub**: Personal account with a [fork of this repository](https://github.com/ned1313/env0-app-example/fork) and the [Network Terraform module repository](https://github.com/ned1313/terraform-azurerm-network/fork).
* **Microsoft Azure**: An Azure subscription with rights to create a service principal in the linked Azure AD tenant and assign Contributor rights to the sub.
* **env0**: A free env0 account and single organization named whatever you want.

## Creating the Azure service principal

There are many directions out there for creating an Azure service principal depending on whether you want to use the portal, CLI, or Terraform. The easiest way is to simply run the Terraform code in the [`service_principal`](./service_principal/) subdirectory of this repository.

Run the following commands from the `service_principal` directory.

```bash
az login

az account set -s "SUBSCRIPTION_NAME"

terraform init
terraform apply -auto-approve
```

When you are done with the demo, run `terraform destroy` to remove the service principal.

## Set up your env0 organization

We will start by creating some things in the env0 organization: cloud credentials, a template, a private module, and organization-level variables.

### Cloud credentials

* From the main env0 console page, click on **Organization -> Settings** and select the *Credentials* tab.
* Scroll down to *Cloud Credentials* and create two credentials with the service principal information from [Creating the Azure service principal](#creating-the-azure-service-principal): *dev-subscription* and *prod-subscription*
  * In a real-world situation, you'd probably have different credentials and subscriptions for dev and prod
* Scroll down to *Cost Credentials* and create two credentials with the same service principal: *dev-subscription-cost* and *prod-subscription-cost*

### Templates

* From the main env0 console page, click on **Organization -> Templates**
* Click on *Create New Template*
* Select *Terraform* as the template type and give it the name *basic-web-app*
* Click *Next*
* Click on GitHub.com for the VCS
  * You will be prompted to connect the env0 app to your GitHub account the first time, follow the directions to complete
* Select your fork of the `env0-app-example` repository from the drop down
* Select the `main` branch and click on *Next*
* Click on *Load Variables From...* to load the variables stored in the Terraform config
* Fill out the values for the following variables:
  * `admin_password`: theseseventrees7!
  * `admin_username`: tacocat
  * `app_subnet`: app
  * `prefix`: env0
  * `subnet_map`: `{"app": "10.0.0.0/24","db": "10.0.1.0/24"}`
  * `vnet_address_space`: `["10.0.0.0/16"]`
* Click *Next* and save the template

### Private Module

* From the main env0 console page, click on **Organization -> Module Registry**
* Click on *Create New Module*
* Fill out the fields
  * Use the module name `network`
  * Use the module provider `azurerm`
* Select GitHub.com from the VCS providers
* Select your fork of the `terraform-azurerm-network` repository
* Click on *Create*
* On the module page, select the *Instructions* tab and note the contents of the `module` block
* In the [`main.tf`](./main.tf) file of this repository, replace the `source` and `version` values with the `module` block values
* Commit and push the change to your fork of this repository

### Organization Variables

* From the main env0 console page, click on **Organization -> Variables**
* Click on *Add Variable* and pick *Dropdown*
* Set the variable key to `organization_tag` and add the single value `taco-co`
* Click on *Add Variable* and pick *Dropdown*
* Set the variable key to `business_unit_tag` and add values `taco`, `burrito`, and `enchilada`
* Click on *Save*

## Create a Project

Now that you've set up your organization, it's time to create your first project!

* From the main env0 console page, click on **Organization -> Projects**
* Click on *Create New Project*
* Name the project `taco-dev`

You will be taken to the project page.

* From the project page click on *Project Templates* and *Manage Templates* to add the `basic-web-app` template to the project
* Click on *Project Variables* and add one variable with the key `environment` and the value `dev`
* Click on *Project Settings* and the *Credentials* Tab
  * Select the *dev-subscription* and *dev-subscription-cost* from the dropdowns
  * Click on *Save*

Your project is ready to go! The next step is to create an environment. Follow the directions in the video to deploy the environment. 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a> [network](#module\_network) | api.env0.com/e02c6435-0492-493d-96bc-55fd7f5a8570/network/azurerm | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | (Required) Password for the admin user. | `string` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Required) Username for the admin user. | `string` | n/a | yes |
| <a name="input_app_port_number"></a> [app\_port\_number](#input\_app\_port\_number) | (Optional) Port number for app. Defaults to 8000. | `number` | `8000` | no |
| <a name="input_app_subnet"></a> [app\_subnet](#input\_app\_subnet) | (Required) Name of subnet for app VM deployment. Must also be in keys from subnet\_map. | `string` | n/a | yes |
| <a name="input_business_unit_tag"></a> [business\_unit\_tag](#input\_business\_unit\_tag) | (Optional) BU tag to apply to all resources. | `string` | `null` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | (Optional) Tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) Environment for Azure resources. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Optional) Region for Azure resources, defaults to East US. | `string` | `"eastus"` | no |
| <a name="input_organization_tag"></a> [organization\_tag](#input\_organization\_tag) | (Optional) Org tag to apply to all resources. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Required) Naming prefix for resources. | `string` | n/a | yes |
| <a name="input_subnet_map"></a> [subnet\_map](#input\_subnet\_map) | (Required) Map of subnet names and address spaces. | `map(string)` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | (Optional) VM size for app. Defaults to Standard\_D2s\_v5. | `string` | `"Standard_D2s_v5"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | (Required) Address space for the virtual network. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_url"></a> [app\_url](#output\_app\_url) | n/a |
<!-- END_TF_DOCS -->