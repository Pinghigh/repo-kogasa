#!/bin/bash

pkgname=$1

useradd builder -m
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod -R a+rw .

echo -e '\n[cachyos]\nServer = https://mirror.cachyos.org/repo/x86_64/$repo\nSigLevel = Never\n\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n\n[archlinuxcn]\nServer = https://mirrors.xtom.us/archlinuxcn/$arch\nServer = https://mirrors.ocf.berkeley.edu/archlinuxcn/$arch\nServer = https://mirrors.aliyun.com/archlinuxcn/$arch\nSigLevel = Never\n' | tee -a /etc/pacman.conf

pacman-key --init
pacman -Syu --noconfirm paru pacman-contrib mold

if test -z "${INPUT_MAKEPKGPROFILEPATH}";then
	echo "Didn't provide makepkg profile path. Skipped."
else
	sudo -H -u builder install -D /etc/makepkg.conf ~/.config/pacman/makepkg.conf # 怕出权限问题所以先传统方式安装
	sudo -H -u cat ${INPUT_MAKEPKGPROFILEPATH} > ~/.config/pacman/makepkg.conf
fi

sudo -H -u builder paru -S --noconfirm --clonedir . $pkgname
