/**
 * A Terraform module that creates S3 bucket and IAM user/key with access to the bucket
**/

resource "aws_iam_user" "sa_user" {
  name = "service-account"
}

resource "aws_iam_access_key" "sa_user_keys" {
  user = "${aws_iam_user.sa_user.name}"
}

// Public bucket
resource "aws_s3_bucket" "public_bucket" {
  bucket = "${var.project_name}-${var.public-bucket-name}"
  force_destroy = "true"

  tags = {
    Name = "public-bucket"
  }
}

resource "aws_s3_bucket_acl" "public_s3_bucket" {
  bucket = aws_s3_bucket.public_bucket.id
  acl = "public-read"
}

// Private bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "${var.project_name}-${var.private-bucket-name}"
  force_destroy = "true"

  tags = {
    Name = "private-bucket"
  }
}

resource "aws_s3_bucket_acl" "private_s3_bucket" {
  bucket = aws_s3_bucket.private_bucket.id
  acl = "private"
}

// Backup bucket
resource "aws_s3_bucket" "backup_bucket" {
  count  = var.is_backup_bucket_needed ? 1 : 0
  bucket = "${var.project_name}-pg-backup"

  tags = {
    Name = "backup-bucket"
  }
}

resource "aws_s3_bucket_acl" "backup_s3_bucket" {
  bucket = aws_s3_bucket.backup_bucket[0].id
  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "private_bucket_access" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

resource "aws_s3_bucket_public_access_block" "backup_bucket_access" {
  bucket = aws_s3_bucket.backup_bucket[0].id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}

# grant user access to the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${aws_s3_bucket.private_bucket.id}"

  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "AWS": "${aws_iam_user.sa_user.arn}"
        },
        "Action": [ "s3:*" ],
        "Resource": [
            "${aws_s3_bucket.private_bucket.arn}",
            "${aws_s3_bucket.private_bucket.arn}/*"
        ]
        }
    ]
    }
    EOF
}

resource "aws_s3_bucket_policy" "backup_bucket_policy" {
  bucket = "${aws_s3_bucket.backup_bucket[0].id}"

  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "AWS": "${aws_iam_user.sa_user.arn}"
        },
        "Action": [ "s3:*" ],
        "Resource": [
            "${aws_s3_bucket.backup_bucket[0].arn}",
            "${aws_s3_bucket.backup_bucket[0].arn}/*"
        ]
        }
    ]
    }
    EOF
}

output "s3_sa_user_access_key" {
  value = aws_iam_access_key.sa_user_keys.id
}