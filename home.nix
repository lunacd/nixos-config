{ inputs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.haowenl =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin
        ./users/haowenl.nix
      ];
    };
}
