
# Cyrus SASL Compilation (`cyrus-sasl-compilation`)

## Description

Ce dépôt met à disposition des outils pour recompiler les paquets `cyrus-sasl` (actuellement, seulement les paquets `.deb` pour Debian), afin d'appliquer des modifications spécifiques et/ou utiles.

## Patches

| Identifier | Description | Related link(s) |
|------------|-------------|-----------------|
| 0100-password-length.patch | Augmente la longueur des mots de passe de 256 à 4096 caractères, utile si vous souhaitez faire passer un token ou toute autre chose plus longue qu'un mot de passe classique | https://github.com/cyrusimap/cyrus-sasl/pull/611 |

## Instructions

1. Contruire l'image Docker appropriée, en utilisant la version de Debian de votre choix (ici: `buster`)
```bash
# ----- args -----
# VERSION - Version de Debian ciblée
#
docker build -t cyrus-sasl-compil:buster -f dockerfiles/debian/Dockerfile --build-arg VERSION=buster .
```

2. En utilisant l'image construite précédemment, lancer la compilation des paquets, en appliquant les patches au passage
```bash
# ----- args -----
# DEB_PREFIX - Prefix that will be added to the package version name
# DEB_EMAIL - Email of the package builder/maintainer
# DEB_NAME - Full name of the package builder/maintainer
#
docker run --rm --name csc-deb-buster \
    -v "$PWD"/scripts:/scripts -v "$PWD"/output/debian/buster:/compil \
    --env DEB_PREFIX=ABC --env DEB_EMAIL=votre.nom@example.com --env DEB_NAME=VotreNom \
    cyrus-sasl-compil:buster /scripts/compil.sh
```

## Exemples

### Exemple - Debian `buster`
```bash
docker build -t cyrus-sasl-compil:buster -f dockerfiles/debian/Dockerfile --build-arg VERSION=buster .

docker run --rm --name csc-deb-buster \
    -v "$PWD"/scripts:/scripts -v "$PWD"/output/debian/buster:/compil \
    --env DEB_PREFIX=ABC --env DEB_EMAIL=votre.nom@example.com --env DEB_NAME=VotreNom \
    cyrus-sasl-compil:buster /scripts/compil.sh
```

### Exemple - Debian `stretch`
```bash
docker build -t cyrus-sasl-compil:stretch -f dockerfiles/debian/Dockerfile --build-arg VERSION=stretch .

docker run --rm --name csc-deb-stretch \
    -v "$PWD"/scripts:/scripts -v "$PWD"/output/debian/stretch:/compil \
    --env DEB_PREFIX=ABC --env DEB_EMAIL=votre.nom@example.com --env DEB_NAME=VotreNom \
    cyrus-sasl-compil:stretch /scripts/compil.sh
```

## Contributors

- **Grégoire GUTTIN** - Scripts et patchs originaux
- **Tom-Brian GARCIA** - Tâches de mise en forme et de traduction pour la publication sur Github