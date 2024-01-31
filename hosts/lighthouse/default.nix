{ config, pkgs, nixpkgs, agenix, ... }:

{
  imports = [
    "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"
    agenix.nixosModules.default
    ../../modules/nix.nix
  ];

  # the ssh keys are set up on the digitalocean web ui
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # TODO: cr in nixpkgs to add option for setting nebula user / group
  age.secrets = {
    nebulaCaCert = {
      file = ../../secrets/nebulaCaCert.age;
      owner = "nebula-home";
      group = "nebula-home";
    };
    nebulaLighthouseCert = {
      file = ../../secrets/nebulaLighthouseCert.age;
      owner = "nebula-home";
      group = "nebula-home";
    };
    nebulaLighthouseKey = {
      file = ../../secrets/nebulaLighthouseKey.age;
      owner = "nebula-home";
      group = "nebula-home";
    };
  };
  networking.firewall.allowedUDPPorts = [ 4242 ];

  services.nebula.networks.home = {
    enable = true;
    isLighthouse = true;
    isRelay = true;
    cert = config.age.secrets.nebulaLighthouseCert.path; # lighthouse.crt
    key = config.age.secrets.nebulaLighthouseKey.path; # lighthouse.key
    ca = config.age.secrets.nebulaCaCert.path; # ca.crt
  };

  system.stateVersion = "23.05";
}
