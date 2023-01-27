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
    scripts ssh;
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
      cloudflared
      ripgrep
      ncdu
      glow
      imagemagick
      audacity
      playerctl
      svtplay-dl
      (pass.withExtensions (ext: with ext; [ pass-import pass-genphrase ]))
      qtpass
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ] ++ builtins.attrValues scripts;

  programs = {
    inherit zsh kitty tmux rofi ssh;
    kakoune = kakoune.program;
    keychain.enable = true;
    git = git {
      allowedSignersFile = home.file.sshAllowedSigners.target;
    };
    jq.enable = true;
    fzf.enable = true;
    direnv = {
      enable = true;
      config = {
        "whitelist" = {
          "prefix" = [ "$HOME/dev/nortical/evl" ];
        };
      };
    };
  };

  services = {
    playerctld.enable = true;
    pasystray.enable = true;
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    flameshot.enable = true;
  };
}
