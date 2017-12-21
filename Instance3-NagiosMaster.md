# Instance 3- Ubuntu 16.04 AMI, 30 GiB
## [Nagios Master Server]

Instance ID: i-024394895fe0d1377
Public DNS: ec2-13-59-117-22.us-east-2.compute.amazonaws.com


### Security-group: launch-wizard-3
	Inbound Traffic
		SSH, Port 22
            HTTP, Port 80
            All traffic, source: sg-4322272b (launch-wizard-1)
	Outbound Traffic
		All allowed on all ports

#### Installed:
- build-essential
- libgd2-xpm-dev
- openssl
- libssl-dev
- apache2-utils
- apache2
- php7.0
- php
- apache2-mod-php7.0
- ssmtp
- libdbd-mysql-perl
- unzip
- libmysqlclient-dev
- libwww-perl


#### COMMANDS RUN
_____________________
###### INSTALL AND CONFIGURE NAGIOS 

sudo apt-get update

sudo apt-get install build-essential libgd2-xpm-dev openssl libssl-dev apache2-utils apache2 php7.0

dd if=/dev/zero of=/swap bs=1024 count=2097152						

mkswap /swap && sudo chown root. /swap && sudo chmod 0600 /swap && sudo swapon /swap

sh -c "echo /swap swap swap defaults 0 0 >> /etc/fstab"

sh -c "echo vm.swappiness = 0 >> /etc/sysctl.conf && sysctl -p"

useradd nagios		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*create user and group for nagios*]

groupadd nagcmd		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*create user and group for nagios*]

sudo su		

wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.0.tar.gz	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*Download NAGIOS*]

tar xvf nagios-*.tar.gz

cd nagios-4.2.0

./configure --with-nagios-group=nagios --with-command-group=nagcmd

apt-get install unzip

make all

make install

make install-commandmode

make install-init

make install-config

/usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

cd

wget http://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*Download NAGIOS plugins*]

tar xvf nagios-plugins-*.tar.gz

cd nagios-plugins-2.1.2

./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl

make

make install

vim /usr/local/nagios/etc/nagios.cfg	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*Edit nagios.cfg file*]

mkdir /usr/local/nagios/etc/servers	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*create folders for servers to be monitored*]

vim /usr/local/nagios/etc/objects/contacts.cfg	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*configure contact email for alerts*]

a2enmod rewrite cgi

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*password is "admin"*]

ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

apt-get install php		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*forgotten in initial installs...*]

service apache2 restart

service nagios restart


_____________________
###### SETTING UP EMAIL FOR NAGIOS ALERTS

sudo apt-get install ssmtp	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*install ssmtp for email capability*]

sudo vim /etc/ssmtp/ssmtp.conf	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*edit config file*]

sudo chown -R nagios:www-data /usr/local/nagios/var/rw/		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*needed to change ownership for nagios to be able to enable notifs*]

>> On Nagios GUI, click enable all notifications for hosts and services.



_____________________
###### SETTING UP MYSQL MONITORING

wget "https://labs.consol.de/assets/downloads/nagios/check_mysql_health-2.2.2.tar.gz"	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*download plugin to monitor mySQL Uptime*]

mkdir /opt/check_mysql

mv check_mysql_health-2.2.2.tar.gz opt/check_mysql

tar -vxzf check_mysql_health-2.2.2.tar.gz	

cd check_mysql_health-2.2.2

./configure

make

make install

apt-get install libdbd-mysql-perl	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*install additional packages needed*]

apt-get install libmysqlclient-dev	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [*install additional packages needed*]

./check_mysql_health -H 172.31.31.131 --username nagios --password creative --mode uptime	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*test plugin*]

vim commands.cfg	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*define command for mySQL Uptime (check_mysql_health)*]

cd ../servers

vim monitor2.cfg	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[*add uptime service to be monitored*]

