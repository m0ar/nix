{ config, pkgs, lib, ... }:
let
  xConfig = import ./xsession.nix;
  i3Config = import ./i3.nix;
  zshConf = import ./zsh.nix;
  gitConf = import ./git.nix;
  kittyConf = (import ./kitty.nix) { fontPkg = pkgs.fira-code; };
  tmuxConf = import ./tmux.nix;
  rofiConf = import ./rofi.nix { inherit pkgs; };
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
  };

  xsession = xConfig {
    i3Config = i3Config { inherit lib pkgs config; };
    inherit pkgs;
  };

  # Enable fc-cache to find nix fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    with import ./scripts.nix { inherit pkgs; }; [
      # Custom scripts
      colortest

      # nixpkgs
      nix-tree
      nixfmt
      bpytop
      google-cloud-sdk
      terraform
      ripgrep
      ncdu
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

  programs.zsh = zshConf;
  programs.kitty = kittyConf;
  programs.git = gitConf {
    inherit pubkey;
    allowedSignersFile = home.file.sshAllowedSigners.target;
  };
  programs.tmux = tmuxConf;
  programs.rofi = rofiConf;
  programs.direnv.enable = true;
  programs.jq.enable = true;
  programs.fzf.enable = true;
}
