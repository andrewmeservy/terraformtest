variable "access_key" {

}
variable "secret_key" {

}

provider "aws" {
  region = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_codebuild_project" "project-with-cache" {
  name          = "TerraformTest"
  description   = "this project is for testing terraform"
  build_timeout = "60"
  service_role  = "arn:aws:iam::019763309060:role/service-role/codebuild-TerraformTest-service-role"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "NO_CACHE"
    modes = []
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    image_pull_credentials_type = "CODEBUILD"
	privileged_mode				= false
	type                        = "LINUX_CONTAINER"
  }

  source {
    buildspec				= "buildspec/buildspec.yml"
    git_clone_depth			= 1
	insecure_ssl			= false
    location				= "https://github.com/andrewmeservy/terraformtest.git"
	report_build_status		= true
	type					= "GITHUB"
  }

  #could put this in vpc?
} 
