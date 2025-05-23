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
    scripts dunst polybar autorandr helix lsd
    flameshot gtk harlequin mpdris2 ncmpcpp
    mopidy chromium nnn beets;
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
    ".ssh/config_source" = {
      source = ./args/ssh/config;
      onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
    };
  } // x.configFiles;

  xsession = x.session;
  inherit gtk;
  
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
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
      xorg.xkill
      openssh
      lsof
      gnumake

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
      code-cursor
      lens
      awscli2
      aws-iam-authenticator
      pnpm_10
      pgadmin4-desktopmode

      # graphical
      audacity
      obsidian
      slack
      discord
      xcolor
      telegram-desktop
      zoom-us
      mixxx
      system-config-printer
      simplescreenrecorder
      vlc
      vault-bin
      inkscape

      # fonts
      fontconfig
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      fira-code
      font-awesome_4

      # own packages
      harlequin
      duckdb
    ] ++ builtins.attrValues scripts ++ builtins.attrValues helix.languageServers ++ (if isNixOS then [
      dbeaver-bin xorg.xmodmap spotify ] else []);

  programs = {
    inherit zsh kitty tmux rofi autorandr lsd ncmpcpp chromium nnn beets;
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
    inherit polybar flameshot mpdris2 mopidy dunst;
    playerctld.enable = true;
    pasystray.enable = true;
    network-manager-applet.enable = true;
    picom.enable = true;
    udiskie.enable = true;
  };
}
