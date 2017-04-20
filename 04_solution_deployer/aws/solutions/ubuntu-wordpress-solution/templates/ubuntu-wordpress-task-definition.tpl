{
  "name": "wordpress-ubuntu",
  "image": "438685710879.dkr.ecr.eu-west-1.amazonaws.com/cycloid/wordpress-ubuntu",
  "memory": 928,
  "cpu": 10,
  "essential": true,
  "environment": [
    {
      "name": "WORDPRESS_DB_HOST",
      "value": "${db_host}"
    },
    {
      "name": "WORDPRESS_DB_PORT",
      "value": "${db_port}"
    },
    {
      "name": "WORDPRESS_DB_USER",
      "value": "${db_user}"
    },
    {
      "name": "WORDPRESS_DB_PASSWORD",
      "value": "${db_password}"
    },
    {
      "name": "WORDPRESS_DB_DATABASE",
      "value": "${db_database}"
    }
  ],
  "portMappings": [
    {
      "containerPort": "80"
    }
  ]
}
