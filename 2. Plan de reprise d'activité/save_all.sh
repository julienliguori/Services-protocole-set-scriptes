#!/bin/sh

# Fichier		: save_all.sh
# Fonction		: Permet de sauvegarder l'ensemble de la configuration du serveur HTTP.
# Planification	: Oui, tout les mois.


# Déclaration des constantes :
ERR_FILE="/var/log/apache2/http_generate_stats.log"	readonly ERR_FILE
SAVE_DIR="/var/snap/apache2"						readonly SAVE_DIR
SAVE_SRC="/etc/apache2/"							readonly SAVE_SRC

# On se place dans le dossier des "snapshots" :
cd $SAVE_DIR

# On supprime la dernière sauvegarde si existante :
LAST_SAVE=$(ls -l | grep -oE "config_.*")
if [ $? -eq 0 ]
then
	rm "$LAST_SAVE"
fi

# On réalise la sauvegarde de la configuration :
tar -cvzf "$SAVE_DIR/config_$(date)" $SAVE_SRC 2> ERR_FILE
