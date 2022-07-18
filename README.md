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