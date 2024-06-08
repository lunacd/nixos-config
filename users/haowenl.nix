{ pkgs, ... }:
{
  catppuccin = {
    flavor = "mocha";
    accent = "green";
  };

  home = {
    packages = with pkgs; [
      # Dev
      tree
      ripgrep
      fd
      xsel

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
      nixfmt-rfc-style

      # Containers
      minikube
    ];

    sessionVariables = {
      # True color
      COLORTERM = "truecolor";
      # Prettierd default configuration path
      PRETTIERD_DEFAULT_CONFIG = "/home/haowenl/.config/haowenl/.prettierrc.json";
      EDITOR = "lvim";
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
    };

    file.lvimConfig = {
      source = ../dotfiles/lvim.lua;
      target = ".config/lvim/config.lua";
      # lunarvim package creates an example config file
      # This option forcedly replace that example config
      force = true;
    };

    stateVersion = "23.11";
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
    gpg = {
      enable = true;
      publicKeys = [
        {
          source = ../public/gpg.pub;
          trust = "ultimate";
        }
      ];
    };

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
        safe.directory = [ "/etc/nixos" ];
        sendemail = {
          annotate = true;
          smtpserver = "smtp.migadu.com";
          smtpuser = "lhw@lunacd.com";
          smtpencryption = "tls";
          smtpserverport = "587";
        };
        "credential \"smtp://smtp.migadu.com:587\"" = {
          helper = "!f() { test \"$1\" = get && echo \"password=$(cat $HOME/.smtpPass)\"; }; f";
        };
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
}
