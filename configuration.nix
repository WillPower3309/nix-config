{ config, pkgs, lib, options, ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/filesystems.nix
    ./modules/users.nix
    ./modules/net.nix
    ./modules/sound.nix
    ./modules/graphical.nix
    ./modules/services.nix
    ./modules/packages.nix
    ./modules/security.nix
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    autoOptimiseStore = true;

    gc = {
      automatic = true;
      dates = "thursday";
      options = "--delete-older-than 8d";
    };
  };

  nixpkgs = {
    overlays = (import ./overlays/init.nix);
    config = {
      allowUnfree = true;
      oraclejdk.accept_license = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Toronto";
  
  system.stateVersion = "20.09";
}

