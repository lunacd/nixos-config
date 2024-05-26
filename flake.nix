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

  outputs = { self, nixpkgs, nixos-wsl, home-manager, catppuccin, sops-nix, ... }: {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            ./configuration.nix
            ./home.nix
          ];
        };
      };
    };
}
