#!/bin/bash

pkgname=$1

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod -R a+rw .

echo -e '\n[cachyos]\nServer = https://mirror.cachyos.org/repo/x86_64/$repo\nSigLevel = Never\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n\n[archlinuxcn]\nServer = https://mirrors.xtom.us/archlinuxcn/$arch\nServer = https://mirrors.ocf.berkeley.edu/archlinuxcn/$arch\nServer = https://mirrors.aliyun.com/archlinuxcn/$arch\nSigLevel = Never\n' | tee -a /etc/pacman.conf

pacman-key --init
pacman -Syu --noconfirm paru pacman-contrib mold

chown -R builder .

ls -a .
ls -a .. 

if test -z "${INPUT_MAKEPKGPROFILEPATH}";then
	sudo -H -u builder paru -S --noconfirm --clonedir . $pkgname
else
    chmod -R a+rw ${INPUT_MAKEPKGPROFILEPATH}
	sudo -H -u builder paru -S $pkgname --mflags "--config ${INPUT_MAKEPKGPROFILEPATH}" --clonedir . --noconfirm
fi