{ config, pkgs, ... }:
let
  username = "haowenl";
in
{
  wsl.enable = true;
  wsl.defaultUser = username;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # For setting fish as default shell
  programs = {
    fish.enable = true;
  };

  virtualisation.podman.enable = true;

  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    name = username;
    description = "Haowen Liu";
    shell = pkgs.fish;
    hashedPasswordFile = config.sops.secrets.haowenlPassword.path;
  };

  services = {
    postgresql = {
      enable = true;
      enableJIT = true;
    };
    pgadmin = {
      enable = true;
      initialEmail = "lhw@lunacd.com";
      initialPasswordFile = "/run/secrets/pgadminPassword";
    };
  };

  system = {
    stateVersion = "23.11";
  };
}
