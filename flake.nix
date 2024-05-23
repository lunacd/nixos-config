{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, catppuccin, ... }:
  let
    username = "haowenl";
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    stateVersion = "23.11";
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
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

            users.users.${username} = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              name = username;
              description = "Haowen Liu";
              shell = pkgs.fish;
            };

            system = {
              inherit stateVersion;
            };
          }
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.haowenl = { config, pkgs, ... }:
            {
              imports = [
                catppuccin.homeManagerModules.catppuccin
                ./home.nix
              ];
            };
          }
        ];
      };
    };
  };
}
