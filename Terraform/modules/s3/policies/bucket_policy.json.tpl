{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowALBWriteLogs",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${elb_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "${bucket_arn}/*"
    },
    {
      "Sid": "AllowLogDeliveryService",
      "Effect": "Allow",
      "Principal": {
        "Service": "logdelivery.elasticloadbalancing.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${bucket_arn}/*"
    }
  ]
}