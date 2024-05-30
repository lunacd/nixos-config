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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      catppuccin,
      sops-nix,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.default
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            ./configuration.nix
            ./home.nix
            ./sops.nix
          ];
        };
      };
    };
}
