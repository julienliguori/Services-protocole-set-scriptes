#!/bin/sh

# Fichier		: save_website.sh
# Fonction		: Permet de sauvegarder le site web en conservant les 7 dernières sauvegardes.
# Planification	: Oui, toutes les semaines à 3h.


# Déclaration des constantes :
ERR_FILE="/var/log/apache2/http_generate_stats.log"	readonly ERR_FILE
SAVE_DIR="/var/snap/apache2"						readonly SAVE_DIR
SAVE_SRC="/etc/apache2/sites-enabled/"				readonly SAVE_SRC

# On se place dans le dossier des "snapshots" :
cd $SAVE_DIR

# On compte le nombre de sauvegardes déjà présentes (on trie les fichiers par date) :
ls -lt | while read -r line
do
	I=$(($I + 1))
	echo $line > lst # On récupère le plus ancien fichier
	echo $I > num	 # On récupères la dernière valeur de I
done
NUM=$(cat num)
LAST=$(cat lst | grep -oE 'carnofluxe_sv_.*')

rm num lst		 	 # On supprime les fichiers temporaires

# Si elles sont au nombre de 7, on supprime la plus ancienne :
if [ $NUM -gt 7 ]
then
	rm "$LAST"
fi

# Enfin, on réalise la sauvegarde du site :
tar -cvzf "$SAVE_DIR/carnofluxe_sv_$(date)" $SAVE_SRC 2> ERR_FILE
