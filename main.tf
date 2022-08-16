 provider "aws" {
    region          = "ap-south-1"
     access_key     = "AKIAUGSFDEBNWOJVGF5J"
     secret_key     = "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"
 }
data "aws_availability_zones" "available" {
  state = "available"
}
 module "vpc-provisioning" {
    source               = "./module/vpc/"
    region               = "ap-south-1"    
    vpc_cidr             = "10.61.0.0/24"
    public_subnet_cidr   = ["10.61.0.0/26", "10.61.0.64/26"]
    public_azs           = ["ap-south-1a", "ap-south-1b"]
    private_subnet_cidr   = ["10.61.0.128/26", "10.61.0.192/26"]
    private_azs           = ["ap-south-1a", "ap-south-1b"]
 }