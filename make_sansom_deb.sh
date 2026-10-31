#!/bin/sh
set -e

# Definición de colores
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARILLO='\033[0;33m'
SIN_COLOR='\033[0m'

WORKDIR="/tmp"
REPO_URL="https://gitlab.com"
DIR_NAME="Sanson-FLinux"

echo "${AZUL}Descargando código desde el repositorio${SIN_COLOR}"
cd "$WORKDIR"

if [ ! -d "$DIR_NAME" ]; then
    git clone "$REPO_URL"
else
    echo "${AMARILLO}El directorio ya existe. Actualizando código...${SIN_COLOR}"
    cd "$DIR_NAME" && git pull && cd "$WORKDIR"
fi

cd "$DIR_NAME"

echo "${AZUL}Leyendo versión dinámica del archivo info${SIN_COLOR}"
VERSION=$(grep -i '^Version:' tcz/sanson.tcz.info | awk '{print $2}' | tr -d '\r')

if [ -z "$VERSION" ]; then
    echo "Error: No se pudo determinar la versión"
    exit 1
fi

echo "${VERDE}Versión detectada: $VERSION${SIN_COLOR}"
DEB_DIR_NAME="sanson_${VERSION}_amd64"
DEB_DIR="$WORKDIR/$DEB_DIR_NAME"

echo "${AZUL}Modificando el Makefile para 64 bits${SIN_COLOR}"
sed -i 's/-march=i686 -mtune=generic //g' Makefile

echo "${AZUL}Compilando el proyecto${SIN_COLOR}"
make clean
make

echo "${AZUL}Creando la estructura de carpetas del paquete${SIN_COLOR}"
rm -rf "$DEB_DIR"
mkdir -p "$DEB_DIR/DEBIAN"
mkdir -p "$DEB_DIR/usr/bin"
mkdir -p "$DEB_DIR/usr/share/applications"
mkdir -p "$DEB_DIR/usr/share/pixmaps"

APP_SHARE_DIR="$DEB_DIR/usr/share/sanson"
mkdir -p "$APP_SHARE_DIR/build"

echo "${AZUL}Copiando binarios y preservando directorios estructurales${SIN_COLOR}"
cp -p build/sanson build/sanson-cli build/sp-test "$APP_SHARE_DIR/build/"

for folder in plugins js scripts assets; do
    if [ -d "$folder" ]; then
        cp -r "$folder" "$APP_SHARE_DIR/"
    fi
done

ln -s /usr/share/sanson/build/sanson "$DEB_DIR/usr/bin/sanson"
ln -s /usr/share/sanson/build/sanson-cli "$DEB_DIR/usr/bin/sanson-cli"
ln -s /usr/share/sanson/build/sp-test "$DEB_DIR/usr/bin/sp-test"

if [ -d "data" ]; then
    [ -f "data/sanson.desktop" ] && cp -p data/sanson.desktop "$DEB_DIR/usr/share/applications/"
    [ -f "data/sanson.png" ] && cp -p data/sanson.png "$DEB_DIR/usr/share/pixmaps/"
fi

echo "${AZUL}Generando archivo de control de Debian${SIN_COLOR}"
cat << EOF > "$DEB_DIR/DEBIAN/control"
Package: sanson
Version: $VERSION
Architecture: amd64
Maintainer: AnddyCort <://gitlab.com>
Depends: libcurl4, libfltk1.3, mplayer
Section: utils
Priority: optional
Description: Sanson: YouTube, Twitch, Kick and music for Linux
 Watch YouTube videos and Twitch and Kick live streams and videos 
 with mplayer, with search, channels, quality choice, audio language 
 and subtitles, live chat, chat replay, YouTube comments, local 
 subscriptions and history.
EOF

echo "${AZUL}Construyendo el archivo .deb final${SIN_COLOR}"
cd "$WORKDIR"
dpkg-deb --root-owner-group --build "$DEB_DIR_NAME"

rm -rf "$DEB_DIR"

echo "${VERDE}Paquete creado con éxito en $WORKDIR/$DEB_DIR_NAME.deb${SIN_COLOR}"

