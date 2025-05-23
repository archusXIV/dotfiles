#!/bin/bash

## Auteur: Y Vollenberg <info@vollenberg.ca> - <https://nordri.vollenberg.ca> - @neoquebecois
## Contibuteur: E Barret <archus@protonmail.com> - LinuxFrench (https://www.youtube.com/@linuxinfrench9388)
##
## licence: LGPL-3.0 (http://opensource.org/licenses/lgpl-3.0.html)
## nordri.sh - Script d'installation pour ArchLinux avec profils Base, XFCE, et Norðri
## Version 4.0
##
## Version: 1.0 sam 14 mai 2022
## Version: 2.0	modifiée et déboguée par LinuxFrench mercredi 29 mars 2023
## Version: 3.0 Réecriture from scratch par Y Vollenberg samedi 1er avril 2023 en s'inspirant de LinuxFrench
## Version: 3.1 Ajout de la detection des disques physiques par Y Vollenberg mercredi 7 mai 2025
## Version: 4.0	Réecriture from scratch par Y Vollenberg lundi 19 mai 2025

set -euo pipefail

# Variables globales
log_file="/tmp/nordri-install.log"
lang="en_US.UTF-8"
kb_layout="us"
profile="base"
ajouter_utilisateur=true
hostname="nordri"

# Fonctions utilitaires
log() {
    echo -e "[\033[1;32mINFO\033[0m] $1" | tee -a "$log_file"
}

error_exit() {
    echo -e "[\033[1;31mERREUR\033[0m] $1" | tee -a "$log_file" >&2
    exit 1
}

# Sélection de la langue et du clavier
choix_langue_clavier() {
    echo "Choisir la langue d'installation :"
    select opt in "Français" "Anglais"; do
        case "$opt" in
            1) lang="fr_CA.UTF-8"; break ;;
            2) lang="en_US.UTF-8"; break ;;
            *) echo "Option invalide" ;;
        esac
    done

    echo "Choisir la disposition du clavier :"
    select opt in "us (Anglais)" "fr (Français de France)" "ca (Français Canadien)"; do
        case "$opt" in
            1) kb_layout="us"; break ;;
            2) kb_layout="fr"; break ;;
            3) kb_layout="ca"; break ;;
            *) echo "Option invalide" ;;
        esac
    done

    loadkeys "$kb_layout"
    export LANG="$lang"
}

# Choix du nom de la machine
choix_nom_machine() {
    echo "Voulez-vous utiliser le nom d'hôte par défaut (nordri) ?"
    select opt in Oui Non; do
        case "$opt" in
            1) hostname="nordri"; break ;;
            2)
                read -rp "Entrez le nom d'hôte souhaité : " hostname
                break
                ;;
            *) echo "Option invalide" ;;
        esac
    done
}

# Menu de sélection de profil
menu() {
    echo "Choisir le profil d'installation: "
    select opt in "Base" "XFCE" "Norðri"; do
        case "$opt" in
            1) profile="base"; ajouter_utilisateur=false; break ;;
            2) profile="xfce"; break ;;
            3) profile="Norðri"; break ;;
            *) echo "Option invalide" ;;
        esac
    done
}

# Détection du disque
detect_disque() {
    declare -a disk_infos=()
    readarray -t disks < <(lsblk -dpno NAME | grep -E "/dev/sd|/dev/nvme|/dev/vd")

    if (( ${#disks[@]} == 0 )); then
        error_exit "Aucun disque détecté."
    fi

    echo "Sélectionner le disque pour l'installation :"
    for i in "${!disks[@]}"; do
        size=$(lsblk -dnbo SIZE "${disks[$i]}" | awk '{ printf "%.1f GB", $1/1024/1024/1024 }')
        echo "$((i+1))) ${disks[$i]} - $size"
        disk_infos+=("${disks[$i]}")
    done

    while true; do
        read -rp "Entrez le numéro du disque: " choix
        if [[ $choix =~ ^[0-9]+$ ]] && (( choix >= 1 && choix <= ${#disk_infos[@]} )); then
            cible="${disk_infos[$((choix-1))]}"
            break
        else
            echo "Option invalide."
        fi
    done
}

# Partitionnement et formatage avec choix du type
partitionner_disque() {
    declare -a table=(
        "Simple (boot + root)"
        "Home séparé (boot + root + home)"
        "Home + swap séparés (boot + root + home + swap)"
    )
    echo "Choisissez le type de partitionnement :"
    select part_opt in "${table[@]}"; do
        case "$part_opt" in
            1)
                log "Partitionnement simple"
                parted -s "$cible" mklabel gpt
                parted -s "$cible" mkpart primary fat32 1MiB 513MiB
                parted -s "$cible" set 1 esp on
                parted -s "$cible" mkpart primary ext4 513MiB 100%
                boot_part="${cible}1"
                root_part="${cible}2"
                home_part=""
                swap_part=""
                break
                ;;
            2)
                log "Partitionnement avec home séparé"
                parted -s "$cible" mklabel gpt
                parted -s "$cible" mkpart primary fat32 1MiB 513MiB
                parted -s "$cible" set 1 esp on
                parted -s "$cible" mkpart primary ext4 513MiB 50%
                parted -s "$cible" mkpart primary ext4 50% 100%
                boot_part="${cible}1"
                root_part="${cible}2"
                home_part="${cible}3"
                swap_part=""
                break
                ;;
            3)
                log "Partitionnement avec home et swap séparés"
                parted -s "$cible" mklabel gpt
                parted -s "$cible" mkpart primary fat32 1MiB 513MiB
                parted -s "$cible" set 1 esp on
                parted -s "$cible" mkpart primary ext4 513MiB 50%
                parted -s "$cible" mkpart primary ext4 50% 90%
                parted -s "$cible" mkpart primary linux-swap 90% 100%
                boot_part="${cible}1"
                root_part="${cible}2"
                home_part="${cible}3"
                swap_part="${cible}4"
                break
                ;;
            *)
                echo "Option invalide"
                ;;
        esac
    done

    log "Formatage des partitions"
    mkfs.fat -F32 "$boot_part"
    mkfs.ext4 -F "$root_part"
    if [[ -n $home_part ]]; then
        mkfs.ext4 -F "$home_part"
    fi
    if [[ -n $swap_part ]]; then
        mkswap "$swap_part"
    fi
}

# Montage des partitions
monter_partitions() {
    mount "$root_part" /mnt
    mkdir -p /mnt/boot
    mount "$boot_part" /mnt/boot
    if [[ -n $home_part ]]; then
        mkdir -p /mnt/home
        mount "$home_part" /mnt/home
    fi
    if [[ -n $swap_part ]]; then
        swapon "$swap_part"
    fi
}

# Installation de base
installation_base() {
    log "Installation de base de Arch Linux"
    pacstrap -K /mnt base linux linux-firmware sudo networkmanager grub efibootmgr
    genfstab -U /mnt >> /mnt/etc/fstab
}

# Configuration système
configuration_systeme() {
    timezone=$(curl -s https://ipapi.co/timezone || echo "Canada/Eastern")

    if [[ $ajouter_utilisateur ]]; then
        read -rp "Nom d'utilisateur à créer : " nom_utilisateur
        while [[ -z $nom_utilisateur ]]; do
            echo "Nom d'utilisateur invalide."
            read -rp "Nom d'utilisateur à créer : " nom_utilisateur
        done

        # Lecture sécurisée du mot de passe, sans le stocker dans une variable
        echo "Création de l'utilisateur $nom_utilisateur"
        arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$nom_utilisateur"

        while true; do
            echo "Entrez le mot de passe pour l'utilisateur $nom_utilisateur: "
            arch-chroot /mnt passwd "$nom_utilisateur" && break
        done

        arch-chroot /mnt sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers
    fi

    arch-chroot /mnt /bin/bash -e <<EOF
        ln -sf "/usr/share/zoneinfo/$timezone" /etc/localtime
        hwclock --systohc
        echo "LANG=$lang" > /etc/locale.conf
        echo "KEYMAP=$kb_layout" > /etc/vconsole.conf
        echo "$hostname" > /etc/hostname

        sed -i "/^#${lang//./\\.}/s/^#//" /etc/locale.gen
        locale-gen

        systemctl enable NetworkManager
        echo "root:arch" | chpasswd
EOF
}

# Installation de GRUB
installation_grub() {
    if [[ -d /sys/firmware/efi ]]; then
        arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    else
        arch-chroot /mnt grub-install --target=i386-pc "$cible"
    fi
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
}

# Installation de logiciels supplémentaires selon le profil
install_complementaire() {
    case "$profile" in
        xfce)
            "Installation du profil XFCE"
            arch-chroot /mnt pacman -S --noconfirm xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xdg-user-dirs firefox
            arch-chroot /mnt systemctl enable lightdm
            ;;
        nordri)
            "Installation du profil Norðri"
            arch-chroot /mnt pacman -S --noconfirm xorg alsa-utils pulseaudio xdg-user-dirs \
                pulseaudio-alsa pulsemixer pavucontrol gst-libav \
                gst-plugins-{bad,base,good,ugly} wavpack \
                cups hplip python-pyqt5 os-prober foomatic-{db,db-ppds,db-gutenprint-ppds,db-nonfree,db-nonfree-ppds} \
                firefox keepass geany gvfs-{afc,goa,google,gphoto2,mtp,nfs,smb} htop  \
                gvfs python-pyinotify lightdm-gtk-greeter lightdm-gtk-greeter-settings \
                wireshark-cli wireshark-qt nmap net-tools tcpdump bind ufw \
                xfce4 xfce4-goodies
            arch-chroot /mnt systemctl enable lightdm
            ;;
    esac
}

afficher_banniere() {
    clear
    cat << "EOF"

       ↑
       |
       N
     Norðri
       |
   ↖   |   ↗
     \ | /
W <--- o ---> E
     / | \
   ↙   |   ↘
       S
       |
       ↓

   Norðri - Script d'installation pour ArchLinux

EOF
}

# Lancement du script
main() {
    afficher_banniere
    choix_langue_clavier
    menu
    choix_nom_machine
    detect_disque
    partitionner_disque
    monter_partitions
    installation_base
    configuration_systeme
    installation_grub
    install_complementaire "$profile"
    log "Installation complétée avec succès. Vous pouvez redémarrer."
}

main "$@"
