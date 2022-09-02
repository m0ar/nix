{ config, pkgs, ... }:
let
  zshSettings = import ./zsh.nix;
  gitSettings = import ./git.nix;
in {
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  home.homeDirectory = "/home/m0ar";
  home.username = "m0ar";

  programs.zsh = zshSettings;
  programs.git = gitSettings;
  programs.direnv.enable = true;
  programs.jq.enable = true;
 }
