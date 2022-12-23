{ i3, pkgs }: {
  session = {
    enable = true;
    windowManager = {
      command = "${pkgs.i3-gaps}/bin/i3";
      i3 = i3.conf;
    };
    initExtra = "";
    profileExtra = ''
      userresources=$HOME/.Xresources
      usermodmap=$HOME/.Xmodmap

      if [ -f "$userresources" ]; then
        xrdb -merge "$userresources"
      fi

      if [ -f "$usermodmap" ]; then
        xmodmap "$usermodmap"
      fi

      if [ -d /etc/X11/xinit/xinitrc.d ] ; then
        for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
          [ -x "$f" ] && . "$f"
        done
        unset f
      fi
    '';
  };

  # resources = {
  #   extraConfig = "";
  #   properties = {
  #       "Xft.dpi" = 96;
  #       "Xft.antialias" = true;
  #       "Xft.hinting" = true;
  #       "Xft.rgba" = "rgb";
  #       "Xft.autohint" = false;
  #       "Xft.hintstyle" = "hintslight";
  #       "Xft.lcdfilter" = "lcddefault";
  #   };
  # };

  configFiles = {
    ".xinitrc".text = ''
      # home-manager creates .xsession starting the VM and other things,
      # so starting it here creates competing processes
      source $HOME/.xsession
    '';

    # ".Xresources".text = ''
    #   Xft.dpi:                          96
    #   Xft.antialias:                    true
    #   Xft.hinting:                      true
    #   Xft.rgba:                         rgb
    #   Xft.autohint:                     false
    #   Xft.hintstyle:                    hintslight
    #   Xft.lcdfilter:                    lcddefault

    #   *background:                      #222D31
    #   *foreground:                      #d8d8d8
    #   *fading:                          8
    #   *fadeColor:                       black
    #   *cursorColor:                     #1ABB9B
    #   *pointerColorBackground:          #2B2C2B
    #   *pointerColorForeground:          #16A085

    #   !! black dark/light
    #   *color0:                          #222D31
    #   *color8:                          #585858

    #   !! red dark/light
    #   *color1:                          #ab4642
    #   *color9:                          #ab4642

    #   !! green dark/light
    #   *color2:                          #7E807E
    #   *color10:                         #8D8F8D

    #   !! yellow dark/light
    #   *color3:                          #f7ca88
    #   *color11:                         #f7ca88

    #   !! blue dark/light
    #   *color4:                          #7cafc2
    #   *color12:                         #7cafc2

    #   !! magenta dark/light
    #   *color5:                          #ba8baf
    #   *color13:                         #ba8baf

    #   !! cyan dark/light
    #   *color6:                          #1ABB9B
    #   *color14:                         #1ABB9B

    #   !! white dark/light
    #   *color7:                          #d8d8d8
    #   *color15:                         #f8f8f8

    #   Xcursor.theme:                    Adawita
    #   Xcursor.size:                     0
    # '';
  };
}
