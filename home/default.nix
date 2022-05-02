{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = [];
  
  imports = [
    ./emacs.nix
    ./zsh.nix
  ];

  home.file = {
    ".config/sway/config".source = ./config/sway/config;
    ".config/oguri/config".source = ./config/oguri/config;
    ".config/foot/foot.ini".source =  ./config/foot/foot.ini;
    ".config/mpv/mpv.conf".source = ./config/mpv/mpv.conf;
    ".config/pipewire/pipewire.conf".source = ./config/pipewire/pipewire.conf;
    ".config/qutebrowser/config.py".source = ./config/qutebrowser/config.py;
  };
}

