# Creating infrastructure on AWS using terraform

## Overview

This repository contains Terraform scripts to provision a basic AWS infrastructure for a web application or service. The infrastructure includes a Virtual Private Cloud (VPC), subnets, Internet Gateway, Route Tables, Network ACLs, Security Groups, an EC2 instance, and a NAT Gateway. These resources are designed to support both public-facing and private components of your application.

## Features

**Modular Structure**: The Terraform scripts are organized into modules for better maintainability and reusability.

**VPC Configuration**: Creates a VPC with specified CIDR block and subnets across multiple availability zones.

**Internet Gateway**: Attaches an Internet Gateway to the VPC to enable internet access for resources.

**Route Tables**: Sets up public and private route tables and associates them with appropriate subnets.

**Network ACLs**: Defines network ACLs to control inbound and outbound traffic at the subnet level.

**Security Groups**: Configures security groups for both public and private resources to manage traffic access.

**EC2 Instance**: Launches an EC2 instance with a specified AMI and instance type in a public subnet.

**NAT Gateway**: Creates a NAT Gateway with an Elastic IP for private subnet internet access.
Usage

**Clone the Repository**: Clone this repository to your local machine using git clone.

**Configuration**: Update the terraform.tfvars file with your AWS access key and secret key.

**Initialize Terraform**: Run terraform init to initialize the working directory.

**Plan**: Run terraform plan to see the execution plan before applying changes.

**Apply Changes**: Run terraform apply to apply the changes and provision the infrastructure.

**Access Resources**: Once the provisioning is complete, you can access your EC2 instance via SSH or other protocols.

## Requirements

Terraform installed on your local machine.
AWS account with appropriate permissions to create and manage resources.

