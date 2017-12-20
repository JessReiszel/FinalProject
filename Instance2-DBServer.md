# Instance 2- Ubuntu 16.04 AMI, 30 GiB
## [DB Server]

Instance ID: i-05f7010e6b0658894
Public DNS: ec2-18-217-201-35.us-east-2.compute.amazonaws.com

### Security-group: launch-wizard-2
	Inbound Traffic
		HTTP, TCP, Port 80
		SSH, Port 22
		All ICMP-IPv4, source:sg-3df2f755 (launch-wizard-3)
            All traffic, source:sg-3df2f755 (launch-wizard-3)
	Outbound Traffic
		All allowed on all ports

#### Installed:
- mysql-server
- nagios-plugins
- nagios-nrpe-server



#### COMMANDS RUN

__________________
###### INSTALLING MYSQL, CONFIGURING DATABASE AND USERS
ssh -i "jess1.pem" ubuntu@ec2-18-217-201-35.us-east-2.compute.amazonaws.com	

sudo apt-get update								

sudo apt-get install mysql-server						**install mysql, set password for root user: "creative"

mysql -u root -p

create database company_inventory;
use company_inventory;
create table inventory (
    -> id int(11) NOT NULL,
    -> itemname varchar(30),
    -> dept varchar(30),
    -> icondition varchar(30),
    -> yearbought int(4),
    -> wholesale decimal(8,2),
    -> retail decimal(8,2),
    -> PRIMARY KEY (id)
    -> );

insert into inventory VALUES (1, 'Arctic Thunder', 'Video Games', 'Good', 2011, 500.00, 700.00),(2, 'Arctic Thunder', 'Video Games', 'Bad', 2009, 500.00, 700.00), (3, 'Cookie Couture', 'Crafts', 'Good', 2014, 1200.00, 1500.00), (4, 'Minute to Win It', 'Game Shows', 'Good', 2012, 1000.00, 1200.00), (5, 'Infinite Photobooth', 'Photos', 'Good', 2015, 1500.00, 1900.00), (6, 'U-Photobooth', 'Photos', 'Bad', 2012, 1100.00, 1300.00), (7, 'XVRG', 'Video Games', 'Good', 2015, 1800.00, 2100.00), (8, 'Air Hockey', 'Sports Games', 'Good', 2008, 500.00, 700.00), (9, 'Video Foosball Table', 'Sports Games', 'Good', 2011, 900.00, 1100.00), (10, 'Mega-Booth', 'Photos', 'Good', 2014, 2000.00, 2400.00);

create user 'readonlyuser'@'localhost' IDENTIFIED BY 'creative';	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*create readonly user*]

grant select on *.* to 'readonlyuser'@'localhost';	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*grant only read privileges*]

create user 'adminuser'@'localhost' IDENTIFIED BY 'creative';	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*create admin user with all privileges*]

grant all privileges on *.* to 'adminuser'@'localhost';		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*grant all privileges to admin user*] 


__________________
###### CREATING BACKUP SCRIPT OF DATABASE
cd home

sudo mkdir sql_backup

cd sql_backup

sudo mkdir sqldata

sudo vim backup.sh 

sudo crontab -e		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*create crontab job to run backups*]


_____________________
###### SETUP NAGIOS AGENTS

sudo apt-get install nagios-plugins nagios-nrpe-server -y

sudo su

vim /etc/nagios/nrpe.cfg

service nagios-nrpe-server restart


_____________________
###### SETTING UP MYSQL UPTIME MONITORING

mysql -u root -p

CREATE USER 'nagios'@'13.59.117.22' IDENTIFIED BY 'creative';

GRANT USAGE ON *.* TO 'nagios'@'13.59.117.22';

CREATE USER 'nagios'@'%' IDENTIFIED BY 'creative';

GRANT USAGE ON *.* TO 'nagios'@'%';

flush privileges;

sudo vim mysqld.cnf	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*edit cnf file to comment out 127.0.0.1 bind address*]

sudo service mysql restart






