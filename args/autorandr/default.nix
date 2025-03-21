{ ... }:
{
  enable = true;
  hooks = {
    postswitch = {
      keyboard-layout = ''
        set -euxo pipefail
        setxkbmap us
        case "$AUTORANDR_CURRENT_PROFILE" in
          office)
            XMODMAP_CONFIG=$HOME/.Xmodmap_split
            ;;
          *)
            XMODMAP_CONFIG=$HOME/.Xmodmap
            ;;
        esac
        xmodmap "$XMODMAP_CONFIG"
      '';
    };
  };
}
