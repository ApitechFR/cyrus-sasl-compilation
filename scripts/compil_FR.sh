#!/bin/bash

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

# Colors constants
LC='\033[1;36m' # Light Cyan
NC='\033[0m' # No color
CSC="[${LC}cyrus-sasl-compilation${NC}]"

# Check if environment variables are defined
if [[ -z ${DEB_PREFIX} ]] || [[ -z ${DEB_EMAIL} ]] || [[ -z ${DEB_NAME} ]]
then
        printf "$CSC Impossible de lancer le script ! Les variables d'environnement DEB_PREFIX, DEB_EMAIL et DEB_NAME sont requises. \n"
        exit 1;
else
        printf "$CSC Lancement du script... \n"
fi

# Check if a proxy is defined
if [ ${HTTP_PROXY} ]
then
    echo "Acquire::http::Proxy \"http://${HTTP_PROXY}\";" >> /etc/apt/apt.conf.d/00proxy
fi

if [ ${HTTPS_PROXY} ]
then
    echo "Acquire::https::Proxy \"https://${HTTPS_PROXY}\";" >> /etc/apt/apt.conf.d/00proxy
fi

# Update package list and packages
apt-get update && apt-get -y upgrade

# Compilation related files
COMPIL_FOLDER='/compil'
COMPIL_VERSION='version'
COMPIL_VERSION_FILE="${COMPIL_FOLDER}/${COMPIL_VERSION}"

# Scripts related files
SCRIPTS_FOLDER='/scripts'
SCRIPTS_0100='0100-password-length.patch'
SCRIPTS_0100_FILE="${SCRIPTS_FOLDER}/${SCRIPTS_0100}"

# Versions related files
CURRENT_VERSION_FILE=${COMPIL_VERSION_FILE}
LATEST_VERSION_FILE="/root/version.tmp"

apt-cache policy sasl2-bin | grep "Candidate" > ${LATEST_VERSION_FILE}
if [ ! -f ${CURRENT_VERSION_FILE} ]; then echo 'none' > ${CURRENT_VERSION_FILE}; fi

printf "$CSC Recherche de nouvelle version... \n"
printf "$CSC Version actuelle : $(cat ${CURRENT_VERSION_FILE}) \n"
printf "$CSC Dernière version : $(cat ${LATEST_VERSION_FILE}) \n"
# cmp ${CURRENT_VERSION_FILE} ${LATEST_VERSION_FILE}
# status=$?

if [[ $(cat ${CURRENT_VERSION_FILE}) = $(cat ${LATEST_VERSION_FILE}) ]]; then
        printf "$CSC Pas de nouvelle version du paquet sasl2-bin ! \n"
        printf "$CSC Pour forcer la recompilation, supprimez le fichier 'output/debian/X/version'. \n"
else
        printf "$CSC Nouvelle version du paquet sasl2-bin trouvée ! \n"
        printf "$CSC Lancement de la recompilation... \n"

        cd /compil
        rm -rf *

        apt-get source sasl2-bin
        src_folder=`ls -d */`

        cp $SCRIPTS_0100_FILE $src_folder/debian/patches/.
        echo $SCRIPTS_0100 >> $src_folder/debian/patches/series

        cd $src_folder
        export DEBEMAIL=${DEB_EMAIL}
        export EMAIL=${DEB_EMAIL}
        export DEBFULLNAME=${DEB_NAME}
        export NAME=${DEB_NAME}

        dch --local "+${DEB_PREFIX}x" "Password length modification"
        debuild -us -uc

        mv ${LATEST_VERSION_FILE} ${CURRENT_VERSION_FILE}

        printf "$CSC Fin de la recompilation ! \n"
fi