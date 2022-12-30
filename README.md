# NIHAT-BLOG-PROJECT-TERRAFORM



# Description:
Hi everybody !! 
I finally finished my big project . 
Here is my Nihat Blog Page Application. With this project I aim to deploy blog application as a web application written Django Framework on AWS Cloud Infrastructure. There are two public, two private subnets and one AZ has NAT Instance (it can be used as bastion host) and public subnets routed internet gateway. This infrastructure has Application Load Balancer with Auto Scaling Group of Elastic Compute Cloud (EC2) Instances and Relational Database Service (RDS) on defined VPC. Also, The Cloudfront and Route 53 services are located in front of the architecture and manage the traffic in secure. User is able to upload pictures and videos on own blog page and these are kept on S3 Bucket. 

Besides creating this AWS project on the console, I wrote a terraform file to create the whole project with terraform.
If you would like to check it out, here is my GitHub link:




# Road Map:

![Project_004](roadmap.png)



# Outcome:


Home Page:

![Project_004](home-page.PNG)


![Project_004](home-page-mobile.jpeg)


![Project_004](certificate.PNG)

Profile Page:

![Project_004](profile-page.PNG)


NOTE: You must customize your variable in  terraform-files/myvars.auto.tfvars file.

![Project_004](myvar.jpg)
