{ i3Config, pkgs }: {
  enable = true;
  initExtra = "";
  profileExtra = "";
  windowManager = {
    command = "${pkgs.i3-gaps}/bin/i3";
    i3 = i3Config;
  };
}
