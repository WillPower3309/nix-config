{ config, pkgs, ... }:

{
  imports = [];

  environment.systemPackages = with pkgs; [
    neofetch
    mpv
    youtube-dl
    keepassxc
    pciutils
    colorls
    nextcloud-client
    unzip
    gtop
    foot
    zsh

    libnotify

    gnome3.nautilus
    openssl

    ripgrep

    imagemagick

    ani-cli

    udiskie

    zoom-us

    obs-studio

    tutanota-desktop

    psmisc # fuser, killall and pstree etc

    wineWowPackages.staging

    # winetricks and other programs depending on wine need to use the same wine version
    winetricks
    mono

    libreoffice

    openconnect
    remmina
    audacity

    python39Packages.psutil

    jdk
  ];
}
