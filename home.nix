{ config, pkgs, ... }:
let
  zshConf = import ./zsh.nix;
  gitConf = import ./git.nix;
  alacrittyConf = (import ./alacritty.nix) { zsh = pkgs.zsh; };
  kittyConf = (import ./kitty.nix) { fontPkg = pkgs.fira-code; };
  tmuxConf = import ./tmux.nix;
in {
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  home.homeDirectory = "/home/m0ar";
  home.username = "m0ar";

  # Enable fc-cache to find nix fonts
  fonts.fontconfig.enable = true;

  programs.zsh = zshConf;
  programs.alacritty = alacrittyConf;
  programs.kitty = kittyConf;
  programs.git = gitConf;
  programs.tmux = tmuxConf;
  programs.direnv.enable = true;
  programs.jq.enable = true;
 }
