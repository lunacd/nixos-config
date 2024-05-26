{ pkgs, ... }: let
  username = "haowenl";
in {
  wsl.enable = true;
  wsl.defaultUser = username;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # For setting fish as default shell
  programs = { fish.enable = true; };

  virtualisation.podman.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    name = username;
    description = "Haowen Liu";
    shell = pkgs.fish;
  };

  system = { stateVersion = "23.11"; };
}
