{ pkgs
, inputs
, isNixOS ? false
# home-manager meta
, lib
, config
, ...
}:
let
  args = import ./args { inherit config pkgs lib inputs isNixOS; };
  inherit (args) pubkey x zsh kitty rofi git tmux
    scripts dunst polybar ssh autorandr helix lsd
    flameshot gtk harlequin mpdris2 ncmpcpp
    mopidy chromium;
in rec {
  targets.genericLinux.enable = lib.mkIf (!isNixOS) true;
  nixpkgs.config = lib.mkIf (!isNixOS) {
    allowUnfree = true;
    allowBroken = true;
  };
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
  home.homeDirectory = "/home/m0ar";
  home.username = "m0ar";
  home.sessionVariables = {
    EDITOR = "hx";
    SUDO_EDITOR = "hx";
    BROWSER = "brave";
  };

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

  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    [
      # meta
      nix-tree
      nix-du
      nixfmt-classic
      nix-diff
      nix-index

      # util
      btop
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
      netcat-openbsd
      bat
      fnm
      yq
      mktorrent
      rsync
      xorg.xev
      zoom-us

      # make dependencies of pixlock script
      scrot

      # programming
      terraform
      kubectl
      kubecolor
      safe
      krew
      diffoci
      k9s
      eksctl
      # vault # suuper heavy build
      nodePackages.yarn
      kubo
      jdk11
      gh
      maven
      rustc
      jetbrains.idea-ultimate

      # graphical
      audacity
      obsidian
      slack
      discord
      xcolor

      # fonts
      fontconfig
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      fira-code
      font-awesome_4

      # own packages
      harlequin
    ] ++ builtins.attrValues scripts ++ builtins.attrValues helix.languageServers;

  programs = {
    inherit zsh kitty tmux rofi ssh autorandr lsd ncmpcpp chromium;
    helix = helix.program;
    git = git {
      allowedSignersFile = home.file.sshAllowedSigners.target;
    };
    direnv.enable = true;
    keychain.enable = true;
    jq.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
  };

  services = {
    inherit polybar flameshot mpdris2 mopidy;
    playerctld.enable = true;
    pasystray.enable = true;
    network-manager-applet.enable = true;
    picom.enable = true;
  };
}
