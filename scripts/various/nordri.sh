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
log_file="nordri-install.log"
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
    echo "Choose in which language the system should be installed ?"
    select _ in "French" "English"; do
        case $REPLY in
            1) lang="fr_CA.UTF-8"; break ;;
            2) lang="en_US.UTF-8"; break ;;
            *) echo "Invalid option" ;;
        esac
    done

    echo "Choose keyboard layout :"
    select _ in "us (English)" "fr (French from France)" "ca (French Canadian)"; do
        case $REPLY in
            1) kb_layout="us"; break ;;
            2) kb_layout="fr"; break ;;
            3) kb_layout="ca"; break ;;
            *) echo "Invalid option" ;;
        esac
    done

    loadkeys "$kb_layout"
    export LANG="$lang"
}

# Choix du nom de la machine
choix_nom_machine() {
    echo "Do you want to use the default hostname (nordri) ?"
    select _ in "Yes" "No"; do
        case $REPLY in
            1)
                hostname="nordri"
                break
            ;;
            2)
                while true; do
                    read -rp "Enter the desired hostname: " new_hostname
                    # Validate hostname:
                    # - Must not be empty
                    # - Must start and end with an alphanumeric character
                    # - Can contain alphanumeric characters and hyphens
                    # - Hyphens cannot be at the beginning or end, or appear consecutively
                    if [[ -z $new_hostname ]]; then
                        echo "Hostname cannot be empty. Please try again."
                    elif [[ ! $new_hostname =~ ^[a-zA-Z0-9]+([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]]; then
                        echo -e "[\033[1;31mERREUR\033[0m] Invalid hostname format. Hostnames can only contain alphanumeric characters and hyphens, and cannot start or end with a hyphen, or contain consecutive hyphens. Please try again."
                    elif [[ $new_hostname =~ -- ]]; then
                        echo -e "[\033[1;31mERREUR\033[0m] Invalid hostname. Hostnames cannot contain consecutive hyphens. Please try again."
                    else
                        hostname="$new_hostname"
                        break
                    fi
                done
                break
            ;;
            *)
                echo -e "[\033[1;31mERREUR\033[0m] Invalid option. Please choose 1 for Yes or 2 for No."
            ;;
        esac
    done
}

# Menu de sélection de profil
menu() {
    echo "Choose the installation profile :"
    select _ in "Base" "XFCE" "Norðri"; do
        case $REPLY in
            1) profile="base"; ajouter_utilisateur=false; break ;;
            2) profile="xfce"; break ;;
            3) profile="Norðri"; break ;;
            *) echo "Invalid option" ;;
        esac
    done
}

detect_disque() {
    local disk_infos=()
    local disks=($(lsblk -dpno NAME | grep -E "/dev/sd|/dev/nvme|/dev/vd"))

    [[ ${#disks[@]} -eq 0 ]] && error_exit "No disk detected."

    echo "Select disk for installation :"
    for i in "${!disks[@]}"; do
        size=$(lsblk -dnbo SIZE "${disks[$i]}" | awk '{ printf "%.1f GB", $1/1024/1024/1024 }')
        echo "$((i+1))) ${disks[$i]} - $size"
        disk_infos+=("${disks[$i]}")
    done

    while true; do
        read -rp "Enter the disk number : " choix
        if [[ "$choix" =~ ^[0-9]+$ ]] && (( choix >= 1 && choix <= ${#disk_infos[@]} )); then
            cible="${disk_infos[$((choix-1))]}"
            break
        else
            echo -e "[\033[1;31mERREUR\033[0m] Invalid option."
        fi
    done
}

# Partitionnement et formatage avec choix du type
partitionner_disque() {
    echo "Choose the partitioning type :"
    select _ in "Simple (boot + root)" "Separate home (boot + root + home)" "Home + separate swap (boot + root + home + swap)"; do
        case $REPLY in
            1)
                log "Simple partitioning"
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
                log "Partitioning with separate home"
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
                log "Partitioning with separate home and swap"
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
            *)  echo -e "[\033[1;31mERREUR\033[0m] Invalid option" ;;
        esac
    done

    log "Formatting partitions"
    mkfs.fat -F32 "$boot_part"
    mkfs.ext4 -F "$root_part"
    if [[ -n "$home_part" ]]; then
        mkfs.ext4 -F "$home_part"
    fi
    if [[ -n "$swap_part" ]]; then
        mkswap "$swap_part"
    fi
}

# Montage des partitions
monter_partitions() {
    mount "$root_part" /mnt
    mkdir -p /mnt/boot
    mount "$boot_part" /mnt/boot
    if [[ -n "$home_part" ]]; then
        mkdir -p /mnt/home
        mount "$home_part" /mnt/home
    fi
    if [[ -n "$swap_part" ]]; then
        swapon "$swap_part"
    fi
}

# Installation de base
installation_base() {
    BASE_ARCH="base linux linux-firmware base-devel pacman-contrib \
        grub efibootmgr networkmanager zip unzip p7zip vi nano wget vim mc git \
        syslog-ng mtools dosfstools lsb-release ntfs-3g exfat-utils bash-completion \
        os-prober man-db man-pages ranger xdg-user-dirs \
        noto-fonts ttf-font-awesome \
        ttf-bitstream-vera ttf-dejavu ttf-fira-code ttf-jetbrains-mono \
        ttf-hack ttf-ibm-plex ttf-liberation"

    log "Basic Installation of Arch Linux"
    clear
    echo ""
    echo -e "[\033[1;32mINFO\033[0m] Basic Installation of Arch Linux "
    echo ""
    sleep 2
    pacstrap -K /mnt a$BASE_ARCH
    #genfstab -U /mnt >> /mnt/etc/fstab
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

# Configuration système
configuration_systeme() {
    timezone=$(curl -s https://ipapi.co/timezone || echo "Canada/Eastern")
    clear && echo ""
    if $ajouter_utilisateur; then
        read -rp "Username to create : " nom_utilisateur
        while [[ -z "$nom_utilisateur" ]]; do
            echo -e  "[\033[1;31mERREUR\033[0m] Invalid username."
            read -rp "Username to create : " nom_utilisateur
        done

        # Lecture sécurisée du mot de passe, sans le stocker dans une variable
        echo -e  "[\033[1;32mINFO\033[0m] User creation $nom_utilisateur"
        arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$nom_utilisateur"

        while true; do
            echo "Enter the password for the user $nom_utilisateur :"
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
    XFCE_PACKAGES="xorg xorg-xinit xf86-input-libinput xfce4 xfce4-goodies \
    lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xdg-user-dirs"

    NORDRI_PACKAGES="xorg xorg-xinit xf86-input-libinput alsa-utils pulseaudio xdg-user-dirs \
        pulseaudio-alsa pulsemixer pavucontrol gst-libav \
        gst-plugins-{bad,base,good,ugly} wavpack \
        cups hplip python-pyqt5 os-prober foomatic-{db,db-ppds,db-gutenprint-ppds,db-nonfree,db-nonfree-ppds} \
        keepass geany gvfs-{afc,goa,google,gphoto2,mtp,nfs,smb} htop  \
        gvfs python-pyinotify lightdm-gtk-greeter lightdm-gtk-greeter-settings \
        wireshark-cli wireshark-qt nmap net-tools tcpdump bind ufw \
        xfce4 xfce4-goodies"

    # HYPERLAND_PACKAGES="hyprland xdg-desktop-portal-hyprland"

    # HYPERLAND_DEPENDANCES="waybar wofi mako hyprpaper \
    #   kitty polkit-gnome xdg-utils \
    #    xdg-user-dirs gvfs pipewire \
    #    pipewire-audio wireplumber \
    #    network-manager-applet \
    #    wl-clipboard grim slurp \
    #    swappy unzip unrar p7zip \
    #    neovim"

    # SWAY_PACKAGES="sway foot wofi waybar mako swaybg network-manager-applet pipewire pipewire-pulse wireplumber brightnessctl grim slurp thunar blueman"

    case "$profile" in
        xfce)
            log "Installing the XFCE profile"n
            sleep 2s
            arch-chroot /mnt pacman -S --noconfirm $XFCE_PACKAGES
            # arch-chroot /mnt pacman -S --noconfirm "$HYPERLAND_PACKAGES"
            # arch-chroot /mnt pacman -S --noconfirm "$HYPERLAND_DEPENDANCES"
            # arch-chroot /mnt pacman -S --noconfirm "$SWAY_PACKAGES"
            arch-chroot /mnt systemctl enable lightdm.service
        ;;
        nordri)
            log "Installing the Norðri profile"
            echo -e "[\033[1;32mINFO\033[0m] Installing the Norðri profile."
            sleep 1s
            arch-chroot /mnt pacman -S --noconfirm $NORDRI_PACKAGES
            arch-chroot /mnt systemctl enable lightdm.service
        ;;
    esac
}

le_temps() {
    echo "Clock synchronization..."
    timedatectl set-ntp true
    timedatectl status
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

   Norðri - Installation script for ArchLinux V.4.1

EOF
}

# Il préférable de tester ceci, car sur une image live nous sommes root
environnement_live() {
    if [[ ! -f /run/archiso/bootmnt/arch/boot/x86_64/vmlinuz-linux ]]; then
        echo -e "[\033[1;31mERREUR\033[0m] This script must be run from the Arch Linux live environment!"
        exit 1
    fi
}
#usager_root () {
#    if [[ $EUID -ne 0 ]]; then
#        echo ""
#        echo -e "[\033[1;31mERREUR\033[0m] This script must be run as root."
#        exit 1
#    elif [[ $EUID -eq 0 ]]; then
#        echo ""
#        echo -e "[\033[1;32mINFO\033[0m] This script run as root."
#        echo ""
#    fi
#}

systeme() {
    if [[ -d /sys/firmware/efi ]]; then
        echo -e "[\033[1;32mINFO\033[0m] The system uses UEFI."
        echo ""
    else
        echo ""
        echo -e "[\033[1;32mINFO\033[0m] The system uses BIOS."
        echo ""
    fi
}

fin()  {
    clear
    echo ""
    read -r -p "Do you want to enter the new installed system? [Y/n]" enter
    case "$enter" in
        y|Y) arch-chroot /mnt ;;
        n|N) umount -R /mnt && reboot ;;
    esac
}

go() {
    echo ""
    read -rs -p " Press enter to continue , ^C to quit:"
}


# Lancement du script
main() {
    afficher_banniere
    go
    le_temps
    #usager_root
    environnement_live
    systeme
    choix_langue_clavier
    menu
    choix_nom_machine
    detect_disque
    partitionner_disque
    monter_partitions
    installation_base
    configuration_systeme
    install_complementaire
    installation_grub
    fin
    log "Installation completed successfully. You can restart.."
}

main "$@"
