#!/bin/bash

pkgname=$1

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod -R a+rw .

echo -e '\n[cachyos]\nServer = https://mirror.cachyos.org/repo/x86_64/$repo\nSigLevel = Never\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n\n[archlinuxcn]\nServer = https://mirrors.xtom.us/archlinuxcn/$arch\nServer = https://mirrors.ocf.berkeley.edu/archlinuxcn/$arch\nServer = https://mirrors.aliyun.com/archlinuxcn/$arch\nSigLevel = Never\n' | tee -a /etc/pacman.conf

pacman-key --init
pacman -Syu --noconfirm paru pacman-contrib
if [ ! -z "$INPUT_PREINSTALLPKGS" ]; then
    pacman -Syu --noconfirm "$INPUT_PREINSTALLPKGS"
fi

git clone https://aur.archlinux.org/$pkgname.git
cd $pkgname
sudo --set-home -u builder paru -U --noconfirm
