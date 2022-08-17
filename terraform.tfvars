environment_name          = "dev"
artifacts_bucket_name     = "krisnom-terraform-state-buckets" #rename to bucket name currently been use
project_repository_owner  = "krishnom"
project_repository_name   = "sample-nodejs-project"
project_repository_branch = "master"

## Build Stage
code_build_project_name = "amb-dev"
#build_image_repo_name   = "870548942328.dkr.ecr.us-west-2.amazonaws.com/tracker-3"
build_image_tag         = "v1"
build_container_name    = "amb-dev"

ecs_cluster_name     = "evo-suite"
ecs_app_service_name = "amb-dev"
aws_region           = "us-east-1"

#project_connection_arn = "arn:aws:codestar-connections:us-west-2:870548942328:connection/f30b7972-ee5e-45dd-a63f-9695b62baa08"
