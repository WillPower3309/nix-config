{ config, pkgs, impermanence, ... }:

let
  desktopKey = "";
  surfaceKey = "";

in
{
  imports = [
    impermanence.nixosModules.impermanence
    ./hardware-configuration.nix
    ../../modules/nix.nix
    ../../modules/bootloader.nix
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    initrd = {
      kernelModules = [ "e1000e" ];

      network = {
        enable = true;

        ssh = {
          enable = true;
          port = 2222;

          hostKeys = [ /persist/etc/ssh/ssh_host_rsa_key ];
          authorizedKeys = [ "${desktopKey}" "${surfaceKey}" ];
        };

       # auto load zfs password prompt on login & kill other prompt so boot can continue
        postCommands = ''
          cat <<EOF > /root/.profile
          if pgrep -x "zfs" > /dev/null
          then
            zfs load-key -a
            killall zfs
          else
            echo "zfs not running -- maybe the pool is taking some time to load"
          fi
          EOF
        '';
      };
    };
  };

  networking = {
    hostName = "server";
    hostId = "276fb82b";
    wireless.enable = false;
  };

  users = {
    users.root.initialPassword = "1012917";
    mutableUsers = false;
  };

  # TODO use zramswap instad of swap partition (from zfs guide in README)

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
    };
    hostKeys = [
      {
        bits = 4096;
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [ "${desktopKey}" "${surfaceKey}" ];

  # Set your time zone.
  time.timeZone = "America/Toronto";

  environment.systemPackages = with pkgs; [ git vim ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # persistence (TODO: make one file)
  programs.fuse.userAllowOther = true;

  environment.persistence."/persist" = {
    directories = [
      "/var/log"
      "/etc/ssh"
    ];
    files = [ "/etc/machine-id" ]; # used by systemd for journalctl
  };

  system.stateVersion = "22.05";
}