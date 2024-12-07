{ pkgs, ... }:
{
  enable = true;
  extensionPackages = with pkgs; [ mopidy-spotify mopidy-mpd mopidy-mpris ];
  extraConfigFiles = [ ~/.config/mopidy/spotify.conf ];
  settings = {
    file = {
      media_dirs = [
        "~/Music|Music"
      ];
      follow_symlinks = true;
      excluded_file_extensions = [
        ".html"
        ".zip"
        ".jpg"
        ".jpeg"
        ".png"
        ".url"
      ];
    };
    mpd = {
      enabled = true;
      hostname = "127.0.0.1";
      port = 6600;
      max_connections = 20;
      connection_timeout = 60;
    };
  };
}
