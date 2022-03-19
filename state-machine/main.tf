###########
#   IAM   #
###########

data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "AssumeEvents"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "random_string" "suffix" {
  length  = 12
  lower   = false
  special = false
}

resource "aws_iam_role" "role" {
  assume_role_policy = data.aws_iam_policy_document.trust.json
  name               = "brutalismbot-states-${var.name}-${random_string.suffix.id}"

  inline_policy {
    name   = "access"
    policy = var.policy
  }
}

#####################
#   STATE MACHINE   #
#####################

resource "aws_sfn_state_machine" "state_machine" {
  definition = jsonencode(yamldecode(templatefile("${path.module}/../definitions/${var.name}.yaml", var.variables)))
  name       = "brutalismbot-${var.name}"
  role_arn   = aws_iam_role.role.arn
}

###############
#   OUTPUTS   #
###############

output "role" { value = aws_iam_role.role }
output "state_machine" { value = aws_sfn_state_machine.state_machine }
