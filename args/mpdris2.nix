{ config, ... }:
{
  enable = true;
  multimediaKeys = true;
  notifications = true;
  mpd = {
    musicDirectory = config.home.homeDirectory + "/Music";
  };
}
