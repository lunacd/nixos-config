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
    home = {
      url = "./home";
      inputs.catppuccin.follows = "catppuccin";
    };
    configuration = {
      url = "./configuration";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, catppuccin, home
    , configuration, ... }: {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.default
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            configuration.nixosModules.configuration
            home.nixosModules.home
          ];
        };
      };
    };
}
