{ inputs
, pkgs
, isNixOS
# home-manager meta
, lib
, config
}:
let
  args = {
    inherit args pkgs lib config isNixOS;
    inherit (inputs) zshPure kak-one kak-rainbower;
    poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };

    autorandr = import ./autorandr args;
    beets = import ./beets.nix args;
    chromium = import ./chromium.nix args;
    dunst = import ./dunst args;
    flameshot = import ./flameshot args;
    git = import ./git.nix args;
    gtk = import ./gtk.nix args;
    harlequin = import ./harlequin.nix args;
    duckdb = import ./duckdb.nix args;
    helix = import ./helix args;
    i3 = import ./i3.nix args;
    kitty = import ./kitty.nix args;
    lsd = import ./lsd args;
    ncmpcpp = import ./ncmpcpp.nix args;
    nnn = import ./nnn.nix args;
    mopidy = import ./mopidy.nix args;
    mpdris2 = import ./mpdris2.nix args;
    polybar = import ./polybar args;
    pubkey = builtins.readFile /home/m0ar/.ssh/id_rsa.pub;
    rofi = import ./rofi.nix args;
    scripts = import ./scripts args;
    ssh = import ./ssh args;
    tmux = import ./tmux args;
    x = import ./x args;
    zsh = import ./zsh args;
  };
in args
