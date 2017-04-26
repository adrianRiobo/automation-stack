# automation-stack
This projects aim to show how to put together several tools to create an automated environment to deploy a solution

## Infrastructure

All solution infrastucture is created in AWS. It uses terraform as infrastructure provisioner. It uses modules to allow re utilization and a better separation of concepts. 
Related with the infrastructute we create some default resources and the expose its ids to allow reutilization in other templates.

Resources in the infrastructure are: 

* infrastructure is a typical multiAz, it has a main VPC with 4 subnets (2 public 2 private). Every pair public-private is created in a different Az.
* ecs cluster where we are going to deploy our solution
* an autoscaling group expanded over the two private subnets (to allow multiAz control of number of instances)
* an application load balancer where we will register our docker service for the solution and it will work as the only
point of entrance in our infrastructure
* all security groups realated with the resources, guarantee just one entry point over the load balancer
* all roles and policies related with ecs services and instances.
* rds instance for wordpress database
* docker private registry to push the docker image created with packer

## Solution builder

Once all infrastructure is setted up. We created a docker image for wordpress, we use packer which allow to make the creation process independent from docker, so we can use the same provisioner to build anything else (virtual image). Also we use ansible as configuration provisioner. In the end packer uses docker as builder and executes ansible as remote, for the building process a docker container is created with the base image and then ansible provisioner connects to it with ssh (we need to pre install python) and configures it. At the end of the process the post processor tag and push the image to our private registry.

## Solution deployer

Again we create all the service definition with terraform. We pass all the variables related with the database connection as environment variables. This allow to configurate the container when is starting. The container also
checks the database connetion before it starts the wordpress. 

The image is pulled from the private registry created with the infrastructure and pushed with packer during the build process

A target group and a listener rules are created to allow communication with the service through the load balancer

## Execution

I create some bash script to allow all the execution you just need some credentials on aws with all the permissions
needed. 

Give execution permission on automation-stack.sh and

automation-stack.sh -a [ACCESS KEY] -s [SECRET KEY]

Also I added some scripts all the stack of products needed: ansible, docker, packer, terraform

## Known issues

Templates can be improved in several way. The amount of variables could be higher allowing more configuration options. Also some typical configuration is create a map of AMIs for the ami in the launch configuration. Due to time the ami is fixed for eu-west-1 region. So if region is changed the solution will not work. This could be changed in next commits.

## Going into production

Although the solution is a good starting point it has several needs before going into production, some of them could be:

* Add EFS to shared data volumes with multiple containers (shared paths)
* Add route 53 to manage request with some rules for updating and geo location
* Add cloudfront to manage ssl and geo replication in a wide range of areas
* Expand Azs, at the time it is using just two, the best configuration is with three (it also expand the numbre of public/private subnets)
* Rules for autoscaling at infrastructure level. We need some cloudwatch rules to scale up and down our scaling group to allow more service instances.
* Rules for autoscaling at service level. As for infrastructure we need to scale up and down our service and again some cloud watch rules are needed.
* Allow multiAz for RDS service and expand its subnet group, also some resizing for the instance it is needed.
* Monitoring: Also we need to create metrics in cloud watch and alarms. Realted with service monitoring we need to provide some monitoring tool like CAdvisor to allow monitoring docker services and also create some alarms. We can go further including some ELK stack or Graylog to allow monitoring servers inside services and also our applications deployed on the servers. 
