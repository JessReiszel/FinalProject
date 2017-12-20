#!/bin/bash


#Database info
username="root"
password="creative"
host="localhost"
db_name="company_inventory"

backup_path="/home/sql_backup/sqldata"
datewritten=$(date +"%b-%d-%T")


#Sets default file permission
umask 177

#Dump the database into an SQL file
mysqldump --user=$username --password=$password --host=$host $db_name > $backup_path/$db_name-$datewritten.sql


#Find backup files in the sqldata folder older than 30 mins and delete them
find $backup_path/* -mmin +30 -exec rm {} \;


                                
