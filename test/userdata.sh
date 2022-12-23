#! /bin/bash
apt-get update -y
apt-get install git -y
apt-get install python3 -y
cd /home/ubuntu/
apt install python3-pip -y
apt-get install python3.7-dev libmysqlclient-dev -y
git clone https://github.com/Nihatcan17/nihat-blog-project.git
cd /home/ubuntu/nihat-blog-project
pip3 install -r requirements.txt
cd /home/ubuntu/nihat-blog-project/src
sed -i "s/'your DB password without any quotes'/${rds-passwd}/g" .env
cd /home/ubuntu/nihat-blog-project/src/cblog
sed -i "s/'database name in RDS is written here'/'${rds-name}'/g" settings.py
sed -i "s/'database master username in RDS is written here'/'${rds-user-name}'/g" settings.py
sed -i "s/'database endpoint is written here'/'${rds-endpoint}'/g" settings.py
sed -i "s/'database port is written here'/'${rds-port}'/g" settings.py
sed -i "s/'please enter your s3 bucket name'/'${BucketName}'/g" settings.py
cd /home/ubuntu/nihat-blog-project/src
python3 manage.py collectstatic --noinput
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:80