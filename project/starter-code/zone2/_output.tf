output "account_id" {
   value = data.aws_caller_identity.current.account_id
 }

 output "caller_arn" {
   value = data.aws_caller_identity.current.arn
 }

 output "caller_user" {
   value = data.aws_caller_identity.current.user_id
 }


 output "vpc_id" {
   value = module.vpc_west.vpc_id
 }

 output "private_subnet_ids" {
   value = module.vpc_west.private_subnet_ids
 }

 output "public_subnet_ids" {
   value = module.vpc_west.public_subnet_ids
 }