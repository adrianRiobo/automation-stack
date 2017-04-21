{
  "name": "jenkins-backup",
  "image": "istepanov/backup-to-s3",
  "memory": 128,
  "cpu": 10,
  "essential": false,
  "environment": [
    {
      "name": "ACCESS_KEY",
      "value": "${aws_access_key}"
    },
    {
      "name": "SECRET_KEY",
      "value": "${aws_secret_key}"
    },
    {
      "name": "S3_PATH",
      "value": "s3://${s3_bucket}/${s3_path}/"
    },
    {
      "name": "CRON_SCHEDULE",
      "value": "0 12 * * *"
    }
  ],
  "mountPoints": [
    {
      "sourceVolume": "jenkins-home",
      "containerPath": "/data"
    }
  ]
}
