resource "aws_codebuild_project" "builder" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "${var.build_timeout}"
  service_role  = "${aws_iam_role.local_codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "traveloka/codebuild-terraform-ci-cd-image:v0.1.6"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "SOME_KEY1"
      "value" = "SOME_VALUE1"
    }

    environment_variable {
      "name"  = "SOME_KEY2"
      "value" = "SOME_VALUE2"
    }
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/mitchellh/packer.git"
    buildspec           = "${data.template_file.ami_buildspec.rendered}"
    git_clone_depth     = "0"
    report_build_status = true
  }

  tags {
    "Environment" = "Test"
  }

//  vpc_config {
//    security_group_ids = []
//    subnets = ["${data.aws_subnet_ids.subnets.ids}"]
//    vpc_id = "${data.aws_vpc.codebuild.id}"
//  }
}
