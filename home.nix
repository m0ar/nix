{ pkgs
, inputs
# home-manager meta
, lib
, config
, ...
}:
let
  args = import ./args { inherit config pkgs lib inputs; };
  inherit (args) pubkey x kakoune zsh kitty rofi git tmux scripts;
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
    # Add additional XDG config files here
    configFile = kakoune.xdgConfigs // { };
  };

  # Enable fc-cache to find nix fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    [
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

  programs.keychain = {
    enable = true;
  };
  programs.zsh = zsh;
  programs.kitty = kitty;
  programs.git = git {
    allowedSignersFile = home.file.sshAllowedSigners.target;
  };
  programs.kakoune = builtins.removeAttrs kakoune [ "xdgConfigs" ];
  programs.tmux = tmux;
  programs.rofi = rofi;
  programs.jq.enable = true;
  programs.fzf.enable = true;
  programs.direnv = {
    enable = true;
    config = {
      "whitelist" = {
        "prefix" = [ "$HOME/dev/nortical/evl" ];
      };
    };
  };
}
