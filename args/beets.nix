{ config
, ...
}:
{
  enable = true;
  settings = {
    library = "/home/${config.home.username}/Music/beets.db";
    log = "/home/${config.home.username}/Music/beets.log";
    directory = "/home/${config.home.username}/Music/library";
    import = {
      copy = "yes";
      write = "yes";
      incremental = "yes";
      move = "no";
      quiet_fallback = "asis";
    };
    plugins = [
      "fetchart" "chroma" "discogs" "lastgenre" "edit" "musicbrainz" "autobpm" "embedart" "fromfilename"
    ];
    chroma = {
      auto = "yes";
    };
  };
}
