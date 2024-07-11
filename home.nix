{ pkgs
, inputs
# home-manager meta
, lib
, config
, ...
}:
let
  args = import ./args { inherit config pkgs lib inputs; };
  inherit (args) pubkey x zsh kitty rofi git tmux
    scripts dunst polybar ssh autorandr helix lsd
    flameshot gtk harlequin;
in rec {
  targets.genericLinux.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      "nodejs-16.20.0"
    ];
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
  inherit gtk;
  
  xdg = {
    enable = true;
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
      xclip
      tree
      dig

      # make dependencies of pixlock script
      scrot

      # programming
      terraform
      nodePackages.yarn
      kubo # ipfs
      jdk11
      gh
      maven
      rustc

      # graphical
      audacity
      obsidian
      slack
      discord

      # fonts
      fontconfig
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      fira-code
      font-awesome_4
    ] ++ builtins.attrValues scripts ++ helix.languageServers;

  programs = {
    inherit zsh kitty tmux rofi ssh autorandr lsd;
    helix = helix.program;
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
    inherit polybar flameshot;
    playerctld.enable = true;
    pasystray.enable = true;
    network-manager-applet.enable = true;
  };
}
