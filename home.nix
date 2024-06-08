{ inputs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.haowenl =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin
        ./users/haowenl.nix
      ];
    };
}
