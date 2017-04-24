#!/bin/bash

usage() {
cat << EOF

Usage: delete-automation-stack.sh -a [ACCESS KEY] -s [SECRET KEY]
Delete infrastucture and service
EOF
exit 0
}

if [ "$#" -eq 0 ]; then usage; fi

while getopts ":a:s:h" optname; do
  case "$optname" in
    "a")
      ACCESS_KEY="$OPTARG"
      ;;
    "s")
      SECRET_KEY="$OPTARG"
      ;;
    "h")
      usage
      ;;
    *)
    # Should not occur
      echo "Unknown error while processing options inside delete-automation-stack.sh"
      ;;
  esac
done

if [ -z "$ACCESS_KEY" ] || [ -z "$SECRET_KEY" ]; then usage; fi

echo 'Removing service and infrastructure'

VPC_ID=$(terraform output -state=outputs/infrastructure.tfstate vpc_id)
DB_HOST=$(terraform output -state=outputs/infrastructure.tfstate rds_address)
DB_PORT=$(terraform output -state=outputs/infrastructure.tfstate rds_port)
DB_USER=wordpress
DB_PASSWORD=wordpress
DB_DATABASE=$(terraform output -state=outputs/infrastructure.tfstate rds_name)
CLUSTER_ID=$(terraform output -state=outputs/infrastructure.tfstate ecs_cluster_id)
ALB_LISTENER_ARN=$(terraform output -state=outputs/infrastructure.tfstate alb_listener_arn)
ECS_SERVICE_ROLE_ARN=$(terraform output -state=outputs/infrastructure.tfstate ecs_service_role_default_arn)

terraform destroy -state=outputs/wordpress-service.tfstate -var "aws_access_key=$ACCESS_KEY" -var "aws_secret_key=$SECRET_KEY" -var "db_host=$DB_HOST" \
 -var "db_port=$DB_PORT" -var "db_user=$DB_USER" -var "db_password=$DB_PASSWORD" -var "db_database=$DB_DATABASE" -var "cluster_id=$CLUSTER_ID" \
 -var "alb_listener_arn=$ALB_LISTENER_ARN" -var "ecs_service_role_default_arn=$ECS_SERVICE_ROLE_ARN" -var "vpc_id=$VPC_ID" 04_solution_deployer/aws/

rm 04_solution_deployer/aws/solutions/ubuntu-wordpress-solution/templates/ubuntu-wordpress-task-definition.json

terraform apply -state=outputs/infrastructure.tfstate -var "aws_access_key=$ACCESS_KEY" -var "aws_secret_key=$SECRET_KEY" 02_infrastructure/aws/

rm -r outputs
