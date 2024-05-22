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
              ];
              catppuccin = {
                flavor = "mocha";
                accent = "green";
              };

              home = {
                inherit stateVersion;
                packages = with pkgs; [
                  # Dev
                  tree
                  ripgrep
                  fd

                  # Editor
                  neovim
                  lunarvim

                  # LSP, formatters, linters
                  lua-language-server
                  clang-tools_17
                  prettierd
                  ruff
                  shellcheck
                  nodePackages.typescript-language-server
                  vscode-langservers-extracted
                  nil

                  # Containers
                  minikube
                ];

                sessionVariables = {
                  # True color
                  COLORTERM = "truecolor";
                  # Prettierd default configuration path
                  PRETTIERD_DEFAULT_CONFIG = "/home/haowenl/.config/haowenl/.prettierrc.json";
                };
              };

              services = {
                gpg-agent = {
                  enable = true;
                  enableSshSupport = true;
                  defaultCacheTtlSsh = 2592000;
                  maxCacheTtl = 2592000;
                  pinentryPackage = pkgs.pinentry-curses;
                };
              };

              programs = {
                gpg.enable = true;

                fish = {
                  enable = true;
                  catppuccin.enable = true;

                  shellAliases = {
                    lg = "lazygit";
                  };
                  shellInit = ''
                    set -gx COLORTERM truecolor
                  '';
                };

                git = {
                  enable = true;
                  userName = "Haowen Liu";
                  userEmail = "lhw@lunacd.com";
                  signing = {
                    key = "F65B4067F3357C78";
                    signByDefault = true;
                  };
                  extraConfig = {
                    core.editor = "lvim";
                    pull.ff = "only";
                    init.defaultBranch = "main";
                    safe.directory = ["/etc/nixos"];
                  };
                };

                keychain = {
                  enable = true;
                  enableFishIntegration = true;
                  keys = [ "id_ed25519" ];
                };

                lazygit = {
                  enable = true;
                  catppuccin.enable = true;
                };

                direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                };
              };
            };
          }
        ];
      };
    };
  };
}
