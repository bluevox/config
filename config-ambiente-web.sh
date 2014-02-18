#!/bin/bash

DOCROOT="/var/www/"
APACHE="/etc/apache2/sites-available/"

#coloque separados por espacos os hostsnames, nao previsa colocar .dev
array=(site)

for i in "${array[@]}"
do	

sudo touch $APACHE$i

echo $APACHE$i" criado"
	
echo '<VirtualHost *:80>

	ServerName '$i'.dev	
	DocumentRoot '$DOCROOT$i'/

	LogFormat "%h %l %u %t \"%r\" %>s %b" common

	ErrorLog  '$DOCROOT$i'/_runtime/error.log
	CustomLog '$DOCROOT$i'/_runtime/access.log common

	<Directory "'$DOCROOT$i'/">
		Options Indexes FollowSymLinks
		Order allow,deny
		allow from all
	</Directory>
	LogLevel error
</VirtualHost>' | sudo tee $APACHE$i

echo "Inserido VirtualHost em "$APACHE$i

if [ ! -d "$DOCROOT$i" ];then
	sudo mkdir $DOCROOT$i
	if [ $? -eq 1 ]; then
        	echo "Diretório "$DOCROOT$i " com sucesso !!!"
    	fi
fi

if [ ! -d "$DOCROOT$i/_runtime" ];then
	sudo mkdir $DOCROOT$i"/_runtime"
	sudo chmod 777 $DOCROOT$i"/_runtime"
	if [ $? -eq 1 ]; then
        	echo "Diretório "$DOCROOT$i'/_runtime' " com sucesso !!!"
    	fi
fi

echo '127.0.0.1 '$i'.dev' | sudo tee -a /etc/hosts > /dev/null	

sudo a2ensite $i
    
done 


echo "Reiniciando Servidor"

sudo service apache2 restart

echo "Servidor Reiniciado"


