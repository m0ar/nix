{ inputs
, pkgs
# home-manager meta
, lib
, config
}:
let
  args = {
    inherit args pkgs lib config;
    inherit (inputs) zshPure;

    i3 = import ./i3.nix args;
    x = import ./x args;
    zsh = import ./zsh args;
    git = import ./git.nix args;
    kitty = import ./kitty.nix args;
    tmux = import ./tmux args;
    rofi = import ./rofi.nix args;
    kakoune = import ./kakoune args;
    pubkey = builtins.readFile /home/m0ar/.ssh/id_rsa.pub;
    scripts = import ./scripts args;
    ssh = import ./ssh args;
  };
in args
