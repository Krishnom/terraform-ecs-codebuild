variable "environment_name" {
  type        = string
  description = "Environment Name"
  default     = "demo"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(any)
  description = "Tags for CodePipelie"
  default     = {}
}

variable "artifacts_bucket_name" {
  type        = string
  description = "S3 bucket name for Build Artificats"
}

variable "artfacts_s3_bucket_encyption_details" {
  type        = map(any)
  description = "Encryption details for the S3 bucket"
  default     = {}
}




## Build Stage Variables
variable "aws_account_id" {
  type    = string
  default = ""
}

#variable "build_image_repo_name" {
#  type        = string
#  description = "Repository Name"
#}

variable "build_environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
      type  = string
  }))
  description = "A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
  default     = []
}

variable "build_image_tag" {
  type        = string
  description = "Image Tag"
}

variable "build_container_name" {
  type        = string
  description = "Application Container Name"
}

variable "code_build_project_name" {
  type        = string
  description = "Code Build Project Name"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Target Amazon ECS Cluster Name"
}

variable "ecs_app_service_name" {
  type        = string
  description = "Target Amazon ECS Cluster NodeJs App Service name"
}

variable "app_count" {
  type = number
  default = 1
}
variable "app_image_name" {
  default = "nginx"
}


#Bitbucket vars
variable "codestar_provider_type" {
  default = "Bitbucket" # "GitHub"
}

variable "project_repository_owner" {
  type        = string
  description = "Project Repository owner of the repository to connect for source code"
}

variable "project_repository_name" {
  type        = string
  description = "Project Repository name to connect for source code"
}

variable "project_repository_branch" {
  type        = string
  description = "Project Repository branch to connect to"
}

variable "poll_for_source_changes" {
  type        = bool
  description = "Poll Repository for changes (True/False)"
  default     = false
}