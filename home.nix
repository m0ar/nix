{ config, pkgs, lib, zshPure, ... }:
let
  i3 = import ./i3.nix { inherit lib pkgs config; };
  x = import ./x.nix { inherit pkgs i3; };
  zshConf = import ./zsh.nix { inherit zshPure; };
  gitConf = import ./git.nix;
  kittyConf = (import ./kitty.nix) { fontPkg = pkgs.fira-code; };
  tmuxConf = import ./tmux.nix;
  rofiConf = import ./rofi.nix { inherit pkgs; };
  kakouneConf = import ./kakoune { inherit pkgs; };
  pubkey = builtins.readFile /home/m0ar/.ssh/id_rsa.pub;
in rec {
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
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
  #xresources = x.resources;

  xdg = {
    enable = true;
    # Add additional XDG config files here
    configFile = kakouneConf.xdgConfigs // {};
  };

  # Enable fc-cache to find nix fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    with import ./scripts.nix { inherit pkgs; }; [
      # Custom scripts
      colortest

      # nixpkgs
      nix-tree
      nix-du
      nixfmt
      nix-diff
      bpytop
      google-cloud-sdk
      terraform
      ripgrep
      ncdu
      glow
      imagemagick
      audacity
      (pass.withExtensions (ext: with ext; [ pass-import pass-genphrase ]))
      qtpass
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

  # services = {
  #   dunst = { enable = true; };
  # };

  programs.keychain = {
    enable = true;
  };
  programs.zsh = zshConf;
  programs.kitty = kittyConf;
  programs.git = gitConf {
    inherit pubkey;
    allowedSignersFile = home.file.sshAllowedSigners.target;
  };
  programs.kakoune = builtins.removeAttrs kakouneConf [ "xdgConfigs" ];
  programs.tmux = tmuxConf;
  programs.rofi = rofiConf;
  programs.jq.enable = true;
  programs.fzf.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    config = {
      "whitelist" = {
        "prefix" = [ "~/dev/nortical/evl" ];
      };
    };
  };
}
