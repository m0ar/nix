{ inputs
, pkgs
# home-manager meta
, lib
, config
}:
let
  args = {
    inherit args pkgs lib config;
    inherit (inputs) zshPure kak-one kak-rainbower;
    poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };

    i3 = import ./i3.nix args;
    x = import ./x args;
    zsh = import ./zsh args;
    git = import ./git.nix args;
    kitty = import ./kitty.nix args;
    tmux = import ./tmux args;
    rofi = import ./rofi.nix args;
    helix = import ./helix args;
    dunst = import ./dunst args;
    polybar = import ./polybar args;
    pubkey = builtins.readFile ~/.ssh/id_rsa.pub;
    scripts = import ./scripts args;
    ssh = import ./ssh args;
    autorandr = import ./autorandr args;
    lsd = import ./lsd args;
    flameshot = import ./flameshot args;
    gtk = import ./gtk.nix args;
    harlequin = import ./harlequin.nix args;
  };
in args
