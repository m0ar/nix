{ config, pkgs, lib, ... }:
let
  xConfig = import ./xsession.nix;
  i3Config = import ./i3.nix;
  zshConf = import ./zsh.nix;
  gitConf = import ./git.nix;
  kittyConf = (import ./kitty.nix) { fontPkg = pkgs.fira-code; };
  tmuxConf = import ./tmux.nix;
in {
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
  home.homeDirectory = "/home/m0ar";
  home.username = "m0ar";

  xsession = xConfig {
    i3Config = i3Config {
      inherit lib;
      inherit pkgs;
    };
    inherit pkgs;
  };

  # Enable fc-cache to find nix fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    with import ./scripts.nix { inherit pkgs; }; [
      # Custom scripts
      colortest

      # nixpkgs
      nixfmt
      google-cloud-sdk
      terraform
      ripgrep
      ncdu
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

  programs.zsh = zshConf;
  programs.kitty = kittyConf;
  programs.git = gitConf;
  programs.tmux = tmuxConf;
  programs.direnv.enable = true;
  programs.jq.enable = true;
  programs.fzf.enable = true;
}
