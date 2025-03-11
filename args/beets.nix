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
      move = "no";
    };
  };
}
