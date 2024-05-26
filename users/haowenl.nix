{ pkgs, ... }: {
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
      PRETTIERD_DEFAULT_CONFIG =
        "/home/haowenl/.config/haowenl/.prettierrc.json";
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
    gpg.enable = true;

    fish = {
      enable = true;
      catppuccin.enable = true;

      shellAliases = { lg = "lazygit"; };
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
