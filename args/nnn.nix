{ pkgs, ... }:
{
  enable = true;
  extraPackages = with pkgs; [ ffmpegthumbnailer mediainfo sxiv ];
  plugins = { };
}
