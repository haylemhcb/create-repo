#!/bin/bash

mkdir repo

# Variables
REPO_DIR=$(pwd)/repo
DISTRO="stable"
ARCH="amd64"
POOL_DIR="$REPO_DIR/pool/main"
DIST_DIR="$REPO_DIR/dists/$DISTRO/main/binary-$ARCH"

# Crear la estructura de directorios
mkdir -p "$POOL_DIR"
mkdir -p "$DIST_DIR"

# Copiar los archivos .deb
echo "Copiando archivos .deb desde /var/cache/apt/archives..."
cp /var/cache/apt/archives/*.deb "$POOL_DIR/"

# Crear el índice del repositorio
echo "Creando el índice del repositorio..."
cd "$DIST_DIR" || exit
dpkg-scanpackages ../../../../pool /dev/null | gzip -9c > Packages.gz

# Crear el archivo Release
echo "Creando el archivo Release..."
{
    echo "Archive: $DISTRO"
    echo "Component: main"
    echo "Origin: RepoHaylem1"
    echo "Label: Disco1"
    echo "Architecture: $ARCH"
} > Release

cd "$REPO_DIR"
genisoimage -o ~/disco.iso -R -J -V "repo" ../repo

# Preparar el CD-ROM
#echo "Preparando el CD-ROM..."
#if command -v growisofs &> /dev/null; then
#    growisofs -Z /dev/cdrom="$REPO_DIR"
#else
#    echo "Error: growisofs no está instalado. Instálalo usando 'sudo apt-get install growisofs'."
#    exit 1
#fi

# Agregar el repositorio a sources.list
#echo "Agregando el repositorio a /etc/apt/sources.list..."
#echo "deb [trusted=yes] cdrom:[Mi Repositorio] ./" | sudo tee -a /etc/apt/sources.list > /dev/null

# Actualizar APT
#echo "Actualizando APT..."
#sudo apt-get update

#echo "CD-ROM creado y configurado correctamente."
