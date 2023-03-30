#!/bin/bash
## Auteur: Yannick Vollenberg
## Contibuteur: LinuxInFrench (https://www.youtube.com/@linuxinfrench9388)
## Version : 2.0.3 - nordri.sh
## Date : sam 14 mai 2022 08:14:02 EST
##
## Sous licence CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/deed.en
## Historique :
## (+)   -> Ajouter quelque chose
## (b)   -> Correction de bogue
## (m)   -> Modifier le fonctionnement des choses
## (-)   -> Supprimer quelque chose
##
## If you test it in real hardware please send me an email to info@vollenberg.ca with
## the machine description and tell me if somethig goes wrong or all works fine.
##
## Si vous testez ce script avec du matériel réel,
## veuillez m'envoyer un courriel à contact info(at)vollenberg.ca avec
## la description de la machine et dites-moi si quelque chose ne va pas
## ou si tout fonctionne bien.
##
## (+) jeudi    03 février 2022    Yannick V     : Création du script
## (+) dimanche 06 février 2022    Yannick V     : Ajout choix installation de la base d'Archlinux
## (m) samedi   14 mai 2022        Yannick V     : Modification du fonctionnement
## (m) mardi    23 août 2022       Yannick V     : Modification du fonctionnement
## (m) mercredi 8 février 2023     Yannick V     : Modification du fonctionnement
## (m) mardi    14 février 2023    Yannick V     : Modification du fonctionnement
## (b) mercredi 29 mars 2023       LinuxInFrench : Correction de bogue
## (+) mercredi 29 mars 2023       LinuxInFrench : Ajouter quelque chose
## 

# COULEURS
Neutre='\e[0;m'
Vert='\e[1;32m'
Rouge='\e[0;31m'
Jaune='\e[1;33m'

#-------------------------------------------------------------------------------#
#                INSTALLATION DE LA VERSION FRANÇAISE                           #
#-------------------------------------------------------------------------------#

# FONCTIONS
base() {
    choix_clavier
    heures
    Part
    format
    monter_part
    mirroir
    installation_base
    gen_fstab
    nom_machine
    fuseau_horaire
    locales
    noyau
    mdproot
    installboot
    network_base
    fin
}

desktop() {
    choix_clavier
    heures
    Part
    format
    monter_part
    mirroir
    installation
    gen_fstab
    nom_machine
    fuseau_horaire
    locales
    noyau
    mdproot
    compteusager
    droitssudo
    installboot
    network
    fin
}

choix_clavier() {
    echo ""
    echo -e "${Neutre}Votre clavier:" ${Vert}[1]" "${Neutre}"Canadien Français, "${Vert}[2]" "${Neutre}Français," "${Vert}[3] ${Neutre}Suisse, ${Vert}[4] ${Neutre}Belge, ${Vert}[5] ${Neutre}Luxembourgeois, ${Vert}[6] ${Neutre}Canadien Anglais ""
    read -p "Votre choix:" CLAVIER

    case "$CLAVIER" in
        1)
            echo "echo -e 'KEYMAP=cf\nFONT=eurlatgr' > /etc/vconsole.conf \
            && nano /etc/locale.gen \
            && echo LANG=fr_CA.UTF-8 > /etc/locale.conf \
            && echo LC_COLLATE=C >> /etc/locale.conf" \
            > clavier  \
            && echo "us" > clavierxorg
        ;;
        2)
            echo "echo -e 'KEYMAP=fr-latin9\nFONT=eurlatgr' > /etc/vconsole.conf \
            && nano /etc/locale.gen \
            && echo LANG=fr_FR.UTF-8 > /etc/locale.conf \
            && echo LC_COLLATE=C >> /etc/locale.conf" \
            > clavier && loadkeys fr  \
            && echo "fr" > clavierxorg
        ;;
        3)
            echo "echo -e 'KEYMAP=fr_CH-latin1' > /etc/vconsole.conf \
            && nano /etc/locale.gen \
            && echo LANG=fr_CH.UTF-8 > /etc/locale.conf" \
            > clavier && loadkeys fr_CH \
            && echo "ch" > clavierxorg
        ;;
        4)
            echo "echo -e 'KEYMAP=be-latin1' > /etc/vconsole.conf \
            && nano /etc/locale.gen \
            && echo LANG=fr_BE.UTF-8 > /etc/locale.conf" \
            > clavier &&  loadkeys be-latin1 \
            && echo "be" > clavierxorg
        ;;
        5)
            echo "echo -e 'KEYMAP=fr-latin9' > /etc/vconsole.conf \
            && nano /etc/locale.gen \
            && echo LANG=fr_LU.UTF-8 > /etc/locale.conf" \
            > clavier &&  loadkeys fr_CH \
            && echo "ch" > clavierxorg
        ;;
        6)
            echo "echo -e 'KEYMAP=us\nFONT=eurlatgr' > /etc/vconsole.conf \
            && nano /etc/locale.gen \
            && echo LANG=fr_CA.UTF-8 > /etc/locale.conf \
            && echo LC_COLLATE=C >> /etc/locale.conf" \
            > clavier  && echo "us" > clavierxorg
        ;;
        *)
            echo "Votre réponse doit être entre 1 à 5" \
            && choix_clavier
        ;;
    esac
}

copyright() {
    GREEN="32"
    BOLDGREEN="\e[1;${GREEN}m"
    ENDCOLOR="\e[0m"
    printf """${BOLDGREEN}
        _   __               __     _
    / | / /___  _________/ /____(_)
    /  |/ / __ \/ ___/ __  / ___/ /
    / /|  / /_/ / /  / /_/ / /  / /
    /_/ |_/\____/_/   \__,_/_/  /_/
    Auteur: Yannick Vollenberg @neoquebecois
    Url: https://nordri.vollenberg.ca
    Blogue: https://blogue.vollenberg.ca
    """
    echo -e "${BOLDGREEN} Un script pour installer Archlinux ! ${ENDCOLOR}"
    echo ""
}

progress() {
    str=" Bienvenue sur Nordri || Welcome to Nordri"
    str1=" Ce script permet l'installation de Archlinux en UEFI sur le premier disque détecté. \n Il est optimisé pour fonctionner avec du matériel Dell  \n \n This script allows the installation of Archlinux in UEFI on the first disk detected. \n It optimized to work with Dell hardware"
    str2="Le partitionnement est fait à l'aide de cfdisk et n'est pas automatique"
    str3="Partitioning is done using cfdisk and is not automatic"

    echo " "
    echo -e ${Vert} $str
    echo " "
    echo " "
    echo -e ${Vert}$str1
    echo " "
    echo -e ${Vert}$str2
    echo " "
    echo -e ${Vert}$str3
    echo " "
}

valider_usager() {
    date=$(date)
    Neutre='\e[0;m'
    Vert='\e[1;32m'
    Rouge='\e[0;31m'
    Jaune='\e[1;33m'
    usager=$(id -u)

    if [[ $usager == 0 ]]; then
        echo -e "${Vert} succès""${Neutre} The script starts $date"
        sleep 1s
    else
        echo -e "${Rouge} Échec""${Neutre} Vous n'êtes pas connecté en tant que ${Jaune}root!"
        sleep 3s
        echo ""
        echo -e "${Neutre} Connectez-vous en tant que ${Jaune}root ${Neutre}et redémarrer le script !!"
        echo ""
        exit 0
    fi
}

erreur() {
    clear && echo ""
    echo -e "${Rouge} MACHINE NON UEFI""${Neutre}"
    echo ""  sleep 4s && exit 0
}

valider_uefi() {
    # ls /sys/firmware/efi/efivars > /dev/null
    # removing "> /dev/null" will work
    if [[ -n $(ls /sys/firmware/efi/efivars) ]]; then
       echo -e "${Vert} Succès""${Neutre} systême UEFI présent! "
    else
       erreur
    exit
   fi
}

choix_langue() {
    echo ""
    echo -e "${Neutre} Your language: ${Vert}[1] ${Neutre}French Canadian, ${Vert}[2] ${Neutre}English."
    echo ""
    read -p " Votre choix:" LANGUE
    case "$LANGUE" in
        1)
          echo -e "${Vert} Succès""${Neutre} votre choix de langue: Canadiens français "
        ;;
        2)
            english_install
        ;;
        *)
            echo " Your answer must be between 1 to 2" \
            && sleep 3 && clear && copyright && choix_langue
        ;;
    esac
}

heures() {
    timedatectl set-ntp true && timedatectl
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de la mise à l'heure du systême "
    else
        echo -e "${Rouge} Échec""${Neutre} de la mise à l'heure du systême "
        sleep 3
        exit
    fi
}

Part() {
    disque=$(lsblk -r | grep disk | cut -d " " -f1 | sed -n '1p')
    cfdisk /dev/$disque
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} du partitionnement du disque "
    else
        echo -e "${Rouge} Échec""${Neutre} du partitionnement du disque "
        sleep 3
        exit
    fi
}

format() {
    sda="/dev/$disque"
    a="1"
    b="2"
    c="3"
    mkfs.fat -F32 $sda$a && mkfs.ext4 $sda$b && mkfs.ext4 $sda$c
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} du formatage des partitions "
    else
        echo -e "${Rouge} Échec""${Neutre} du formatage des partitions "
        sleep 3
        exit
    fi
}

monter_part() {
    sda="/dev/$disque"
    a="1"
    b="2"
    c="3"
    mount $sda$b /mnt && mkdir /mnt/home && mount $sda$c /mnt/home \
    && mkdir /mnt/boot && mount $sda$a /mnt/boot && lsblk
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} du montage des partitions "
    else
        echo -e "${Rouge} Échec""${Neutre} du montage des partitions "
        exit
    fi
}

mirroir() {
    pays=$(curl --fail -s https://ipapi.co/country)
    curl -s -L "https://archlinux.org/mirrorlist/?country=$pays&protocol=https" -o mirrorlist \
    && grep -E 'https' mirrorlist |sed -s 's/^#Server/Server/'
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de la configuration du mirroir"
    else
        echo -e "${Rouge} Échec""${Neutre} de la configuration du mirroir"
        sleep 3
        exit
    fi
}

type_install() {
    echo ""
    echo -e "${Neutre} Installer: ${Vert}[1] ${Neutre}La base uniquement, ${Vert}[2] ${Neutre} Complet avec XFCE et les applications."
    echo ""
    read -p " Votre choix:" TYPE
    case "$TYPE" in
        1)
            base
        ;;
        2)
           desktop
        ;;
        *)
            echo " Votre réponse doit être comprise entre 1 et 2" \
            && clear && type_install  
        ;;
    esac
 }

installation_base() {
    pacstrap /mnt base linux linux-firmware base-devel pacman-contrib \
    grub efibootmgr networkmanager zip unzip p7zip vi nano wget vim mc git \
    syslog-ng mtools dosfstools lsb-release ntfs-3g exfat-utils bash-completion \
    xf86-video-{amdgpu,ati,dummy,fbdev,intel,nouveau,openchrome,qxl,sisusb,vesa} \
    neofetch os-prober man-db man-pages
    if [[ $? -eq 0 ]]; then 
        echo -e "${Vert} Succès""${Neutre} de l'installation de la base"
    else
        echo -e "${Rouge} Échec""${Neutre} de l'installation de la base"
        exit
    fi
 }

installation() {
    pacstrap /mnt base linux linux-headers linux-firmware base-devel \
    pacman-contrib grub efibootmgr networkmanager network-manager-applet \
    zip unzip p7zip vi nano wget vim mc alsa-utils syslog-ng mtools dosfstools \
    lsb-release ntfs-3g exfat-utils bash-completion man-db man-pages xdg-user-dirs \
    xf86-video-{amdgpu,ati,dummy,fbdev,intel,nouveau,openchrome,qxl,sisusb,vesa} \
    ttf-{bitstream-vera,liberation,freefont,dejavu} freetype2 cups hplip python-pyqt5 \
    os-prober foomatic-{db,db-ppds,db-gutenprint-ppds,db-nonfree,db-nonfree-ppds} \
    gutenprint libreoffice-still-fr hunspell-fr firefox firefox-i18n-fr \
    thunderbird thunderbird-i18n-fr keepass geany simplescreenrecorder \
    wireshark-cli wireshark-qt nmap net-tools tcpdump bind firewalld \
    neofetch ntp cronie gst-plugins-{base,good,bad,ugly} gst-libav \
    virtualbox virtualbox-host-modules-arch git gvfs-{afc,goa,google,gphoto2,mtp,nfs,smb} \
    xfce4 xfce4-goodies gvfs python-pyinotify lightdm-gtk-greeter \
    xarchiver galculator evince ffmpegthumbnailer pavucontrol pulseaudio-{alsa,bluetooth} \
    blueman system-config-printer lightdm-gtk-greeter-settings
    if [[ $? -eq 0 ]]; then 
        echo -e "${Vert} Succès${Neutre} de l'installation de la base d'XFCE et des applications."
    else
        echo -e "${Rouge} Échec${Neutre} de l'installation de la base d'XFCE et des applications."
        exit
    fi
}

gen_fstab() {
    genfstab -U -p /mnt >> /mnt/etc/fstab
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès${Neutre} de la génération de /etc/fstab."
    else
        echo -e "${Rouge} Échec${Neutre} de la génération de /etc/fstab."
        exit
    fi
}

nom_machine() {
    echo -e "${Vert} Renseignez le nom de la machine:"
    read machine
    arch-chroot /mnt /bin/bash -c "
        echo $machine > /etc/hostname \
        && echo 127.0.0.1 $machine.localdomain $machine >> /etc/hosts
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert}Succès${Neutre} le nom de la machine est $machine"
    else
        echo -e "${Rouge}Échec${Neutre} nom de la machine non renseigné"
        sleep 3
        exit
    fi
}

fuseau_horaire() {
    timezone=$(curl --fail https://ipapi.co/timezone)
    arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/$timezone /etc/localtime"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès${Neutre} le fuseau horaire est $timezone"
    else
        echo -e "${Rouge} Échec${Neutre} de la configuration du fuseau horaire"
        sleep 3
        exit
    fi
}

locales() {
    locale=$(cat clavier)
    arch-chroot /mnt /bin/bash -c "$locale && locale-gen && hwclock --systohc --utc"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès${Neutre} de la configuration des locales"
    else
        echo -e "${Rouge} Échec${Neutre} de la configuration des locales"
        sleep 3
        exit
    fi
}

noyau() {
arch-chroot /mnt /bin/bash -c "mkinitcpio -p linux"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de la génération de l'image du noyau"
    else
        echo -e "${Rouge} Échec""${Neutre} de la génération de l'image du noyau"
        sleep 3
        exit
    fi
}

mdproot() {
    echo -e "${Vert} Changer le mot de passe de $USER:"
    arch-chroot /mnt /bin/bash -c "passwd $USER"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} du changement du mot de passe de $USER"
        sleep 2
    else
        echo -e "${Rouge} Échec""${Neutre} du changement du mot de passe de $USER"
        exit
    fi
}

compteusager() {
    echo -e "${Vert} Quel est votre nom complet:"
    read nom
    echo -e "${Vert} Quel nom utiliser pour l'ouverture de session:"
    read session
    arch-chroot /mnt /bin/bash -c "
        useradd -m -g wheel -c '$nom' -s /bin/bash $session \
        && passwd $session && gpasswd -a $session vboxusers
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de la configuration du compte de l'usager $nom"
    else
        echo -e "${Rouge} Échec""${Neutre} de la configuration du compte de l'usager $nom"
        sleep 3
        exit
    fi
}

droitssudo() {
    arch-chroot /mnt /bin/bash -c "nano /etc/sudoers"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de la configuration des droits sudo"
    else
        echo -e "${Rouge} Échec""${Neutre} de la configuration des droits sudo"
        sleep 3
        exit
    fi
}

installboot() {
    arch-chroot /mnt /bin/bash -c "
        grub-install --target=x86_64-efi --efi-directory=/boot \
        --bootloader-id=GRUB && grub-mkconfig -o /boot/grub/grub.cfg
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de l'installation du bootloader"
    else
        echo -e "${Rouge} Échec""${Neutre} de l'installation du bootloader"
        sleep 3
        exit
    fi
}

network() {
    xorg=$(cat clavierxorg)
    arch-chroot /mnt /bin/bash -c "
        systemctl enable NetworkManager && systemctl enable lightdm.service \
        && systemctl enable cups \
        && curl -s -O "https://nordri.vollenberg.ca/sh/extra.sh" && chmod +x ./extra.sh \
        && curl -s -O "https://nordri.vollenberg.ca/sh/LISEZ-MOI.txt" \
        && mv {extra.sh,LISEZ-MOI.txt} /home/$session
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de l'installation NetworkManager"
    else
        echo -e "${Rouge} Échec""${Neutre} de l'installation de NetworkManager"
        sleep 3
        exit
    fi
}

fin() {
    umount -R /mnt && reboot
}

network_base() {
    SESS="root"``
    arch-chroot /mnt /bin/bash -c "
        systemctl enable NetworkManager && curl -s -O "https://nordri.vollenberg.ca/sh/extra.sh" \
        && chmod +x ./extra.sh && curl -s -O "https://nordri.vollenberg.ca/sh/LISEZ-MOI.txt" \
        && mv {extra.sh,LISEZ-MOI.txt} /$SESS
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} Succès""${Neutre} de l'installation NetworkManager"
    else
        echo -e "${Rouge} Échec""${Neutre} de l'installation de NetworkManager"
        sleep 3
        exit
    fi
}

#-------------------------------------------------------------------------------#
#                INSTALLATION DE LA VERSION ANGLAISE                            #
#-------------------------------------------------------------------------------#

english_base() {
    choix_clavier
    english_heures
    english_Part
    english_format
    english_monter_part
    english_mirroir
    english_installation_base
    english_gen_fstab
    english_nom_machine
    english_fuseau_horaire
    english_locales
    english_noyau
    english_mdproot
    english_installboot
    english_network_base
    english_fin
}

english_desktop() {
    choix_clavier
    english_heures
    english_Part
    english_format
    english_monter_part
    english_mirroir
    english_installation
    english_gen_fstab
    english_nom_machine
    english_fuseau_horaire
    english_locales
    english_noyau
    english_mdproot
    english_compteusager
    english_droitssudo
    english_installboot
    english_network
    english_fin
}

english_install() {
    echo ""
    echo -e "${Neutre} Install: ${Vert}[1] ${Neutre}The base only, ${Vert}[2] ${Neutre} Complete with XFCE and apps,"
    echo ""
    read -p " Your choice:" TYPE
     case "$TYPE" in
        1)
            english_base
        ;;
        2)
           english_desktop
        ;;
        *)
            echo " Your answer must be between 1 and 2" \
            && sleep 2 && clear \
            && english_copyright && english_install
        ;;
    esac
}

english_copyright(){
    GREEN="32"
    BOLDGREEN="\e[1;${GREEN}m"
    ENDCOLOR="\e[0m"
    printf """${BOLDGREEN}
        _   __               __     _
    / | / /___  _________/ /____(_)
    /  |/ / __ \/ ___/ __  / ___/ /
    / /|  / /_/ / /  / /_/ / /  / /
    /_/ |_/\____/_/   \__,_/_/  /_/
    Author: Yannick Vollenberg @neoquebecois
    Url: https://nordri.vollenberg.ca
    Blog: https://blogue.vollenberg.ca
    """
    echo -e "${BOLDGREEN} A script to install Archlinux! ${ENDCOLOR}"
    echo ""
}

english_heures() {
    timedatectl set-ntp true && timedatectl
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} system time setting "
    else
        echo -e "${Rouge} FAILED""${Neutre} system time setting "
        sleep 3
        exit
    fi
}

english_Part() {
    disque=$(lsblk -r | grep disk | cut -d " " -f1 | sed -n '1p')
    cfdisk /dev/$disque
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} disk partitioning "
    else
        echo -e "${Rouge} FAILED""${Neutre} disk partitioning "
        sleep 3
        exit
    fi
}

english_format() {
    sda="/dev/$disque"
    a="1"
    b="2"
    c="3"
    mkfs.fat -F32 $sda$a && mkfs.ext4 $sda$b && mkfs.ext4 $sda$c
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} partition formatting "
    else
        echo -e "${Rouge} FAILED""${Neutre} partition formatting "
        sleep 3
        exit
    fi
}

english_monter_part() {
    sda="/dev/$disque"
    a="1"
    b="2"
    c="3"
    mount $sda$b /mnt && mkdir /mnt/home \
    && mount $sda$c /mnt/home && mkdir /mnt/boot \
    && mount $sda$a /mnt/boot && lsblk
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} mounting partitions "
    else
        echo -e "${Rouge} FAILED""${Neutre}mounting partitions "
        exit
    fi
}

english_mirroir() {
    pays=$(curl --fail -s https://ipapi.co/country)
    curl -s -L "https://archlinux.org/mirrorlist/?country=$pays&protocol=https" -o mirrorlist \
    && grep -E 'https' mirrorlist | sed -s 's/^#Server/Server/'
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert}OK""${Neutre} mirror configuration"
    else
        echo -e "${Rouge}FAILED""${Neutre} mirror configuration"
        sleep 3
        exit
    fi
}

english_installation_base() {
    pacstrap /mnt base linux linux-firmware base-devel pacman-contrib \
    grub efibootmgr networkmanager zip unzip p7zip vi nano wget vim mc git \
    syslog-ng mtools dosfstools lsb-release ntfs-3g exfat-utils bash-completion \
    xf86-video-{amdgpu,ati,dummy,fbdev,intel,nouveau,openchrome,qxl,sisusb,vesa} \
    neofetch os-prober man-db man-pages
    if [[ $? -eq 0 ]]; then 
        echo -e "${Vert} OK""${Neutre} of the installation of the base"
    else
        echo -e "${Rouge} FAILED""${Neutre} of the installation of the base"
        exit
    fi
 }

english_installation() {
    pacstrap /mnt base linux linux-headers linux-firmware base-devel \
    pacman-contrib grub efibootmgr networkmanager network-manager-applet \
    zip unzip p7zip vi nano wget vim mc alsa-utils syslog-ng mtools dosfstools \
    lsb-release ntfs-3g exfat-utils bash-completion man-db man-pages xdg-user-dirs \
    xf86-video-{amdgpu,ati,dummy,fbdev,intel,nouveau,openchrome,qxl,sisusb,vesa} \
    ttf-{bitstream-vera,liberation,freefont,dejavu} freetype2 cups hplip python-pyqt5 \
    os-prober foomatic-{db,db-ppds,db-gutenprint-ppds,db-nonfree,db-nonfree-ppds} \
    gutenprint libreoffice-still hunspell-en_us firefox firefox-i18n-en-us \
    thunderbird thunderbird-i18n-en-us keepass geany simplescreenrecorder \
    wireshark-cli wireshark-qt nmap net-tools tcpdump bind firewalld \
    neofetch ntp cronie gst-plugins-{base,good,bad,ugly} gst-libav \
    virtualbox virtualbox-host-modules-arch git gvfs-{afc,goa,google,gphoto2,mtp,nfs,smb} \
    xfce4 xfce4-goodies gvfs python-pyinotify lightdm-gtk-greeter \
    xarchiver galculator evince ffmpegthumbnailer pavucontrol pulseaudio-{alsa,bluetooth} \
    blueman system-config-printer lightdm-gtk-greeter-settings
    if [[ $? -eq 0 ]]; then 
        echo -e "${Vert} OK""${Neutre} installing the XFCE database and applications"
    else
        echo -e "${Rouge} FAILED""${Neutre} installing the XFCE database and applications"
        exit
    fi
}

english_gen_fstab() {
    genfstab -U -p /mnt >> /mnt/etc/fstab && pacstrap /mnt grub os-prober efibootmgr
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} /etc/fstab generation"
    else
        echo -e "${Rouge} FAILED""${Neutre} /etc/fstab generation"
        exit
    fi
}

english_nom_machine() {
    echo -e "${Vert} Fill in the name of the machine:"
    read machine
    arch-chroot /mnt /bin/bash -c "
        echo $machine > /etc/hostname \
        && echo 127.0.0.1 $machine.localdomain $machine >> /etc/hosts
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} the name of the machine is $machine"
    else
        echo -e "${Rouge} FAILED""${Neutre} machine name not specified"
        sleep 3
        exit
    fi
}

english_fuseau_horaire() {
    timezone=$(curl --fail https://ipapi.co/timezone)
    arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/$timezone /etc/localtime"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} the time zone is $timezone"
    else
        echo -e "${Rouge} FAILED""${Neutre} time zone configuration"
        sleep 3
        exit
    fi
}

english_locales() {
    locale=$(cat clavier)
    arch-chroot /mnt /bin/bash -c "$locale && locale-gen && hwclock --systohc --utc"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} local configuration"
    else
        echo -e "${Rouge} FAILED""${Neutre} local configuration"
        sleep 3
        exit
    fi
}

english_noyau() {
    arch-chroot /mnt /bin/bash -c "mkinitcpio -p linux"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} kernel image generation"
    else
        echo -e "${Rouge} FAILED""${Neutre} kernel image generation"
        sleep 3
        exit
    fi
}

english_mdproot() {
    echo -e "${Vert} Change the password of $USER:"
    arch-chroot /mnt /bin/bash -c "passwd $USER"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} password change de $USER"
        sleep 2
    else
        echo -e "${Rouge} FAILED""${Neutre} password change $USER"
        exit
    fi
}

english_compteusager() {
    echo -e "${Vert} What is your full name:"
    read nom
    echo -e "${Vert} What name to use for login:"
    read session
    arch-chroot /mnt /bin/bash -c "
        useradd -m -g wheel -c '$nom' -s /bin/bash $session \
        && passwd $session && gpasswd -a $session vboxusers
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} the configuration of the user's account $nom"
    else
        echo -e "${Rouge} FAILED""${Neutre} the configuration of the user's account $nom"
        sleep 3
        exit
    fi
}

english_droitssudo() {
    arch-chroot /mnt /bin/bash -c "nano /etc/sudoers"
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert}OK""${Neutre} sudo rights configuration"
    else
        echo -e "${Rouge}FAILED""${Neutre} sudo rights configuration"
        sleep 3
        exit
    fi
}

english_installboot() {
    arch-chroot /mnt /bin/bash -c "
        grub-install --target=x86_64-efi --efi-directory=/boot \
        --bootloader-id=GRUB && grub-mkconfig -o /boot/grub/grub.cfg
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} installing the bootloader"
    else
        echo -e "${Rouge} FAILED""${Neutre} installing the bootloader"
        sleep 3
        exit
    fi
}

english_network() {
    xorg=$(cat clavierxorg)
    arch-chroot /mnt /bin/bash -c "
        systemctl enable NetworkManager && systemctl enable lightdm.service \
        && systemctl enable cups \
        && curl -s -O "https://nordri.vollenberg.ca/sh/extra.sh" && chmod +x ./extra.sh \
        && curl -s -O "https://nordri.vollenberg.ca/sh/LISEZ-MOI.txt" \
        && mv {extra.sh,LISEZ-MOI.txt} /home/$session
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} NetworkManager installation"
    else
        echo -e "${Rouge} FAILED""${Neutre} NetworkManager installation"
        sleep 3
        exit
    fi
}

english_fin() {
    umount -R /mnt && reboot
}

english_network_base() {
    SESS="root"``
    arch-chroot /mnt /bin/bash -c "
        systemctl enable NetworkManager && curl -s -O "https://nordri.vollenberg.ca/sh/extra.sh" \
        && chmod +x ./extra.sh && curl -s -O "https://nordri.vollenberg.ca/sh/LISEZ-MOI.txt" \
        && mv {extra.sh,LISEZ-MOI.txt} /$SESS
    "
    if [[ $? -eq 0 ]]; then
        echo -e "${Vert} OK""${Neutre} NetworkManager installation"
    else
        echo -e "${Rouge} FAILED""${Neutre} NetworkManager installation"
        sleep 3
        exit
    fi
}

#-------------------------------------------------------------------------------#
# ÉTAPES 1 à 8
clear
progress
copyright
valider_usager
valider_uefi
choix_langue
type_install
