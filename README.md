# NIHAT-BLOG-PROJECT-TERRAFORM



# Description:

Here is my Nihat Blog Page Application. With this project I aim to deploy blog application as a web application written Django Framework on AWS Cloud Infrastructure. There are two public, two private subnets and one AZ has NAT Instance (it can be used as bastion host) and public subnets routed internet gateway. This infrastructure has Application Load Balancer with Auto Scaling Group of Elastic Compute Cloud (EC2) Instances and Relational Database Service (RDS) on defined VPC. Also, The Cloudfront and Route 53 services are located in front of the architecture and manage the traffic in secure. User is able to upload pictures and videos on own blog page and these are kept on S3 Bucket. 

Besides creating this AWS project on the console, I wrote a terraform file to create the whole project with terraform.





# Road Map:

![Project_004](project-images/roadmap.png)



# AWS - Console

VPC: 

![Project_004](project-images/vpc.PNG)


Public Route Table: 

![Project_004](project-images/public-route-table.PNG)


Private Route Table: 

![Project_004](project-images/private-route-table.PNG)

Security Groups:

Load Balancer Security Group:

![Project_004](project-images/loadbalancer-sg.PNG)

RDS Security Group:

![Project_004](project-images/rds-sg.PNG)

NAT Instace Security Group:

![Project_004](project-images/nat-instance-sg.PNG)

Blog Instance Security Group: 

![Project_004](project-images/blog-instance-sg.PNG)


Blog Instance:

![Project_004](project-images/blog-instance.PNG)


Nat Instance: 

![Project_004](project-images/nat-instace.PNG)

Target Group:

![Project_004](project-images/target-group.PNG)


Load Balancer:

![Project_004](project-images/load-balacer.PNG)

Auto Scaling Group:

![Project_004](project-images/asg.PNG)

S3 Bucket:

![Project_004](project-images/s3bucket.PNG)


DynamoDB Table:

![Project_004](project-images/dynamodb-table.PNG)


Lambda:

![Project_004](project-images/lamda.PNG)


Cloudfront:

![Project_004](project-images/cloud-front.PNG)


Route53:

![Project_004](project-images/route-53.PNG)



# Outcome:


Home Page:

![Project_004](project-images/home-page.PNG)


![Project_004](project-images/home-page-mobile.jpeg)


![Project_004](project-images/certificate.PNG)

Profile Page:

![Project_004](project-images/profile-page.PNG)


Post Page:

![Project_004](project-images/create-post.PNG)

# Note !!

Dont forget customize terraform-files/myvars.auto.tfvars file !!

![Project_004](project-images/myvars.PNG)