# NIHAT-BLOG-PROJECT-TERRAFORM



# Description:

Here is my Nihat Blog Page Application. With this project I aim to deploy blog application as a web application written Django Framework on AWS Cloud Infrastructure. There are two public, two private subnets and one AZ has NAT Instance (it can be used as bastion host) and public subnets routed internet gateway. This infrastructure has Application Load Balancer with Auto Scaling Group of Elastic Compute Cloud (EC2) Instances and Relational Database Service (RDS) on defined VPC. Also, The Cloudfront and Route 53 services are located in front of the architecture and manage the traffic in secure. User is able to upload pictures and videos on own blog page and these are kept on S3 Bucket. 

Besides creating this AWS project on the console, I wrote a terraform file to create the whole project with terraform.





# Road Map:

![Project_004](roadmap.png)



# AWS - Console

VPC: 

![Project_004](vpc.PNG)


Public Route Table: 

![Project_004](public-route-table.PNG)


Private Route Table: 

![Project_004](private-route-table.PNG)

Security Groups:

Load Balancer Security Group:

![Project_004](loadbalancer-sg.PNG)

RDS Security Group:

![Project_004](rds-sg.PNG)

NAT Instace Security Group:

![Project_004](nat-instance-sg.PNG)

Blog Instance Security Group: 

![Project_004](blog-instance-sg.PNG)


Blog Instance:

![Project_004](blog-instance.PNG)


Nat Instance: 

![Project_004](nat-instace.PNG)

Target Group:

![Project_004](target-group.PNG)


Load Balancer:

![Project_004](load-balacer.PNG)

Auto Scaling Group:

![Project_004](asg.PNG)

S3 Bucket:

![Project_004](s3bucket.PNG)


DynamoDB Table:

![Project_004](dynamodb-table.PNG)


Lambda:

![Project_004](lamda.PNG)


Cloudfront:

![Project_004](cloud-front.PNG)


Route53:

![Project_004](route-53.PNG)



# Outcome:


Home Page:

![Project_004](home-page.PNG)


![Project_004](home-page-mobile.jpeg)


![Project_004](certificate.PNG)

Profile Page:

![Project_004](profile-page.PNG)


Post Page:

![Project_004](create-post.PNG)

# Note !!

Dont forget customize terraform-files/myvars.auto.tfvars file !!

![Project_004](myvars.PNG)