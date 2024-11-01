{ pkgs
, inputs
# home-manager meta
, lib
, config
, ...
}:
let
  args = import ./args { inherit config pkgs lib inputs; };
  inherit (args) pubkey zsh kitty git scripts ssh helix lsd;
in rec {
  targets.genericLinux.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
  home.homeDirectory = "/home/osmc";
  home.username = "osmc";
  home.sessionVariables = {
    EDITOR = "hx";
    SUDO_EDITOR = "hx";
  };

  # Link extra configuration files
  home.file = {
    sshAllowedSigners = {
      target = ".ssh/allowed_signers";
      text = programs.git.userEmail + " " + pubkey;
    };
  };
  
  # Enable fc-cache to find nix fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;
    [
      # utils
      btop
      unzip
      ncdu
      glow
      xclip
      bat

      # fonts
      fontconfig
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      fira-code
      font-awesome_4
    ] ++ builtins.attrValues helix.languageServers;

  programs = {
    inherit zsh kitty ssh lsd;
    helix = helix.program;
    git = git {
      allowedSignersFile = home.file.sshAllowedSigners.target;
    };
    keychain.enable = true;
    jq.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
  };
}
