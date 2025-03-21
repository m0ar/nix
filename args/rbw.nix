{ pkgs, ... }:
{
  enable = true;
  settings = {
    email = "edvard@hubinette.me";
    lock_timeout = 60 * 3;
    sync_interval = 60 * 20;
    pinentry = pkgs.pinentry-gtk2;
  };
}
