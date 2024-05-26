{
  inputs = { catppuccin.url = "github:catppuccin/nix"; };
  outputs = { self, catppuccin, ... }: {
    nixosModules = {
      home = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.haowenl = { config, pkgs, ... }: {
          imports =
            [ catppuccin.homeManagerModules.catppuccin ./users/haowenl.nix ];
        };
      };
    };
  };
}
