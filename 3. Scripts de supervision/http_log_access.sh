#!/bin/sh

# Fichier	: http_log_access.sh
# Fonction	: Permet de générer un fichier CSV à partir du journal de connexion du serveur
#			  Apache, renseignant l'IP du visiteur et sa géolocalisation.
# Planification	: Oui, toutes les heures.


# Déclaration des constantes :
ERR_FILE="/var/log/apache2/http_log_access.log";						readonly ERR_FILE
LOG_FILE="/var/log/apache2/access.log";									readonly LOG_FILE
CSV_FILE="/var/log/apache2/access.csv";									readonly CSV_FILE
HOUR=$(date | grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' | cut -d ':' -f1);	readonly HOUR

# On insère les catégories dans le CSV local :
echo "IP,Country,Region,Ville" > $CSV_FILE

# Récupération de l'IP :
grep -E '' $LOG_FILE | while read -r line
do
	# On vérifie si la ligne est vide :
	if [ "$line" = "" ]
	then
		continue
	fi

	# On vérifie si la connexion date de la dernière heure :
	HOURS=$(echo $line | grep -oE ':[0-9]{2}:[0-9]{2}:[0-9]{2}' | cut -d ':' -f2)
	if [ "$HOURS" -eq "$(($HOUR - 1))" ]
	then
		# Récupération de l'adresse IP :
		IP=$(echo $line | grep -oE '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}') 2> ERR_FILE

		# Récupération des informations liées à cet IP (curl doit être installé) :
		IP_INFO=$(curl -sg http://ip-api.com/csv/$IP)  2> ERR_FILE

		# On contrôle les échecs de la requête :
		if [ $(echo $IP_INFO | cut -d ',' -f1) != "success" ]
		then
			echo "Echec, impossible de collecter les informations !"

			IP_COUNTRY="Indisponible"
			IP_REGION="Indisponible"
			IP_CITY="Indisponible"
		else
			# Récupération des informations de localisation :
			IP_COUNTRY=$(echo $IP_INFO | cut -d ',' -f2)	# Le pays
			IP_REGION=$(echo $IP_INFO | cut -d ',' -f5)		# La région
			IP_CITY=$(echo $IP_INFO | cut -d ',' -f6)		# La ville
		fi

		# Ecriture du CSV local :
		echo $IP,$IP_COUNTRY,$IP_REGION,$IP_CITY >> $CSV_FILE
	fi
done
