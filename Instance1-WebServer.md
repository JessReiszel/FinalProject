# Instance 1- Ubuntu 16.04 AMI, 30 GiB
### [Web Server]

Instance ID: i-0f4a7a8bb8fcc44fb
Public DNS: ec2-18-217-151-132.us-east-2.compute.amazonaws.com

#### Security-group: launch-wizard-2
	Inbound Traffic
		HTTP, TCP, Port 80
		SSH, Port 22
		All ICMP-IPv4, source:sg-3df2f755 (launch-wizard-3)
	Outbound Traffic
		All allowed on all ports

#### Installed:
- Apache2
- Nagios-plugins
- nagios-nrpe-server


#### COMMANDS RUN
sudo apt-get install apache2

cd var/www/html

sudo vim index.html	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	[*create custom landing page*] 

cd home/ubuntu

mkdir myStuff		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	[*folder for my site files*]

sudo chmod 777 myStuff		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	[*allow access to transfer file here*]


[*Commands from virtual-desktop to secure copy background image file to ec2 instance*] 

jess@jess-VirtualBox:~$ sudo scp -i ~/Desktop/Keys/jess1.pem ~/Desktop/Final_Project_Files/roadBG.jpg 

ubuntu@ec2-18-217-151-132.us-east-2.compute.amazonaws.com:/home/ubuntu/myStuff	

sudo cp /home/ubuntu/myStuff/roadBG.jpg /var/www/html	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*copy file to html folder*]

cd /var/www/html

sudo mkdir images   	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	[*Made an images folder for site images*]

mv roadBG.jpg images	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	[*put bg image in images folder*]

sudo vim stylesheet.css	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	[*created stylesheet for index.html to reference*]

sudo vim index.html	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	[*configured index.html to point to my stylesheet*]


_____________________
##### AFTER NAGIOS SETUP ON MASTER NAGIOS SERVER

sudo apt-get install nagios-plugins nagios-nrpe-server -y

sudo su

vim /etc/nagios/nrpe.cfg

service nagios-nrpe-server restart

