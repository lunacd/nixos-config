{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }:
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

            programs = {
              fish.enable = true;

              # TODO: on 24.05, use the one from home-manager instead
              gnupg.agent = {
                enable = true;
                pinentryFlavor = "curses";
                enableSSHSupport = true;
                # Remember passphrase for a month
                settings = {
                  default-cache-ttl = 2592000;
                  max-cache-ttl = 2592000;
                };
              };
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
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.haowenl = { config, pkgs, ... }:
            {
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
                  TERM = "xterm-direct";
                  # Prettierd default configuration path
                  PRETTIERD_DEFAULT_CONFIG = "/home/haowenl/.config/haowenl/.prettierrc.json";
                };
              };

              programs = {
                home-manager.enable = true;
                
                fish = {
                  enable = true;

                  shellAliases = {
                    lg = "lazygit";
                  };
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
                  # Use catppuccin/nix when stable channel is supported
                  # https://github.com/catppuccin/nix/issues/155
                  settings = {
                    gui = {
                      theme = {
                        activeBorderColor = [ "#a6e3a1" "bold" ];
                        inactiveBorderColor = [ "#a6adc8" ];
                        optionsTextColor = [ "#89b4fa" ];
                        selectedLineBgColor = [ "#313244" ];
                        cherryPickedCommitBgColor = [ "#45475a" ];
                        cherryPickedCommitFgColor = [ "#a6e3a1" ];
                        unstagedChangesColor = [ "#f38ba8" ];
                        defaultFgColor = [ "#cdd6f4" ];
                        searchingActiveBorderColor = [ "#f9e2af" ];
                      };
                      authorColors = {
                        "*" = "#b4befe";
                      };
                    };
                  };
                };
              };
            };
          }
        ];
      };
    };
  };
}
