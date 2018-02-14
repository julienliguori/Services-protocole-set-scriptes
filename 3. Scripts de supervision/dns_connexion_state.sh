#!/bin/sh

# Fichier	: dns_connexion_state.sh
# Fonction	: Permet de tester l'état de la connexion ainsi que de la résolution de nom.
#			  Les résultats seront écrits dans un CSV et transférés au serveur HTTP.
# Planification	: Oui, toutes les 5 minutes.


# Déclaration des constantes :
IP_HTTP="192.168.10.10"			     			readonly IP_HTTP
WEB_NAME="www.carnoflux.fr"		     			readonly WEB_NAME
CSV_FILE="state.csv"			     			readonly CSV_FILE
CSV_DESTINATION="/var/log/apache2/state.csv"	readonly CSV_DESTINATION

# On effectue un ping vers le serveur HTTP :
PING=$(ping -qc 5 "$IP_HTTP")
PING_VALID=$?

# On effectue un ping vers le nom du site web :
NAME=$(ping -qc 5 "$WEB_NAME")
NAME_VALID=$?

# On écrit dans le CSV local le résultat du fonctionnement :
if [ $PING_VALID -eq 0 ]
then
	echo "Server connexion,Yes" > $CSV_FILE
else
	echo "Server connexion,No" > $CSV_FILE
fi

if [ $NAME_VALID -eq 0 ]
then
	echo "Name resolution,Yes" >> $CSV_FILE
else
	echo "Name resolution,No" >> $CSV_FILE
fi

# On envoie le fichier CSV local au serveur HTTP via SSH et la commande "scp" :
scp -r -p $CSV_FILE username@$IP_HTTP:$CSV_DESTINATION
