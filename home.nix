{ pkgs
, inputs
# home-manager meta
, lib
, config
, ...
}:
let
  args = import ./args { inherit config pkgs lib inputs; };
  inherit (args) pubkey x kakoune zsh kitty rofi git tmux
    scripts dunst polybar ssh;
in rec {
  targets.genericLinux.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  home.homeDirectory = "/home/m0ar";
  home.username = "m0ar";

  # Link extra configuration files
  home.file = {
    sshAllowedSigners = {
      target = ".ssh/allowed_signers";
      text = programs.git.userEmail + " " + pubkey;
    };
  } // x.configFiles;

  xsession = x.session;

  xdg = {
    enable = true;
    configFile = kakoune.xdgConfigs
      // dunst.configFiles;
  };

  # Enable fc-cache to find nix fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    [
      # meta
      nix-tree
      nix-du
      nixfmt
      nix-diff

      # util
      btop
      ripgrep
      unzip
      ncdu
      glow
      imagemagick
      (pass.withExtensions (ext: with ext; [ pass-import pass-genphrase ]))
      qtpass
      playerctl

      # programming
      terraform
      cloudflared

      # media
      audacity
      svtplay-dl

      # social
      obsidian
      slack
      discord
      tdesktop # telegram

      # fonts
      fontconfig
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      fira-code
      font-awesome_4
    ] ++ builtins.attrValues scripts;

  programs = {
    inherit zsh kitty tmux rofi ssh;
    kakoune = kakoune.program;
    git = git {
      allowedSignersFile = home.file.sshAllowedSigners.target;
    };
    direnv = {
      enable = true;
      config = {
        "whitelist" = {
          "prefix" = [ "/home/m0ar/dev/nortical/evl" ];
        };
      };
    };
    keychain.enable = true;
    jq.enable = true;
    fzf.enable = true;
  };

  services = {
    inherit polybar;
    playerctld.enable = true;
    pasystray.enable = true;
    # blueman-applet.enable = true;
    network-manager-applet.enable = true;
    flameshot.enable = true;
  };
}
