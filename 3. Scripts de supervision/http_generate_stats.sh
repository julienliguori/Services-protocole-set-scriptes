#!/bin/sh

# Fichier		: http_generate_stats.sh
# Fonction		: Permet de générer une page HTML a partir des fichiers CSV précédemment créés.
# Planification	: Oui, toutes les 5 minutes.


# Déclaration des constantes :
ERR_FILE="/var/log/apache2/http_generate_stats.log"	readonly ERR_FILE
HTTP_CSV="/var/log/apache2/access.csv"				readonly HTTP_CSV
DNS_CSV="/var/log/apache2/state.csv"				readonly DNS_CSV
TEMP_CSV="/var/log/apache2/input.csv"				readonly TEMP_CSV
WEBSITE="/etc/apache2/sites-enabled/index.html"		readonly WEBSITE

# On concatène les deux fichiers :
cat $HTTP_CSV $DNS_CSV > $TEMP_CSV

# On génère le site Web (nécessite le script python "csv2http") :
csv2http -o $WEBSITE $TEMP_CSV 2> ERR_FILE
