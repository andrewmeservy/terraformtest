variable "access_key" {

}
variable "secret_key" {

}
variable "github_personal_access_token" {
  #default = ""
}

provider "aws" {
  region = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

provider "github" {
  token = "${var.github_personal_access_token}"
  individual = false
  organization = "andrewmeservy"
}

# resource "aws_codebuild_webhook" "terraformTest" {
#   project_name = "${aws_codebuild_project.terraformTest.name}"
# }

resource "aws_codebuild_webhook" "example" {
  project_name = "${aws_codebuild_project.terraformTest.name}"

  filter_group {
    filter {
      type = "EVENT"
      pattern = "PULL_REQUEST_MERGED"
    }

    filter {
      type = "HEAD_REF"
      pattern = "master"
    }
  }
}

# resource "github_repository_webhook" "terraformTest" {
#   active     = true
#   events     = ["PULL_REQUEST_MERGED"]
#   repository = "terraformtest"

#   configuration {
#     url          = "${aws_codebuild_webhook.terraformTest.payload_url}"
#     secret       = "${aws_codebuild_webhook.terraformTest.secret}"
#     content_type = "json"
#     insecure_ssl = false
#   }
# }

resource "aws_codebuild_project" "terraformTest" {
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
