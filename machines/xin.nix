{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./xin-hardware.nix
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    # HW graphics acceleration
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    display = {
      edid = {
        enable = true;
        linuxhw = {
          P32p-30 = [ "P32p-30" ];
        };
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "m0ar" ];
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      # kernelModules = [ "amdgpu" ];
      luks.devices = {
        "cryptlvm" = {
          device = "/dev/nvme0n1p6";
          preLVM = true;
        };
      };
    };
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev"; 
        # useOSProber = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  systemd = {
    sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };

  fileSystems = {
    "/" = lib.mkForce {
      device = "/dev/nixos/root";
      fsType = "ext4";
    };
    "/boot" = lib.mkForce {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };
  };

  swapDevices = lib.mkForce [
    { device = "/dev/nixos/swap"; }
  ];

  networking = {
    hostName = "xin";
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true; 
      wifi = {
        backend = "iwd";
        powersave = true;
      };
      dispatcherScripts = [{
        source = ../args/networkmanager/99-wifi-auto-toggle;
        type = "basic";
      }];
    };
    firewall.enable = false;
    hosts = {
      "172.17.0.1" = [ "host.docker.internal" ];
    };
  };

  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services = {
    dbus = {
      enable = true;
      packages = [  pkgs.dconf ];
    };
    gnome = {
      gnome-keyring.enable = true;
    };
    xserver = {
      enable = true;
      exportConfiguration = true;
      displayManager.startx.enable = true;
      videoDrivers = [ "amdgpu" ];
      deviceSection = ''
        Option "TearFree" "true"
      '';
      xkb = {
        layout = "us";
        options = "eurosign:e,caps:escape";
      };
    };
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
      };
    };
    autorandr = let
      fingerprint = {
        laptop = "00ffffffffffff0009e5b40c0000000034210104a51d1378070aa5a7554b9f250c505400000001010101010101010101010101010101119140a0b0807470302036001dbe1000001a000000fd001e78f4f44a010a202020202020000000fe00424f45204e4a0a202020202020000000fc004e4531333541314d2d4e59310a023170207902002000139a0e00b40c000000003417074e4531334e593121001d220b6c07400b8007886efa54b8749f56820c023554d05fd05f483512782200144c550b883f0b9f002f001f007f077300020005002500094c550b4c550b1e7880810013721a000003011e7800006a426a427800000000000000000000000000004f907020790000260009020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003690";
        office = "00ffffffffffff0030aed163443242361f210104b54627783e9da5ae5046a2240e5054adef00714f8180818a9500a9c0a9cfb300d1cf4dd000a0f0703e8030203500b9882100001a000000ff0056333042364232440a20202020000000fd00324b1da03c010a202020202020000000fc00503332702d33300a202020202001d2020322f14a01030204901211131f612309070783010000e305c000e60605015a343d023a801871382d40582c4500b9882100001ecc7400a0a0a01e5030203500b9882100001a565e00a0a0a0295030203500b9882100001e00000000000000000000000000000000000000000000000000000000000000000000000000000057";
        home = "00ffffffffffff0010ac794255534d411c220104b53c22783adf15ad5044ad250f5054a54b00d100d1c0b300a94081808100714fe1c04dd000a0f0703e803020350055502100001a000000ff004a4439594733340a2020202020000000fc0044454c4c20553237323351450a000000fd0017560f8c36010a2020202020200108020317f14a101f20041312110302012309070783010000a36600a0f0701f803020350055502100001a565e00a0a0a029503020350055502100001a114400a080001f503020360055502100001abf1600a08038134030203a0055502100001a0000000000000000000000000000000000000000000000000000000000000000a9";
      };
    in {
      enable = true;
      matchEdid = true;
      profiles = {
        default = {
          inherit fingerprint;
          config = {
            laptop = {
              enable = true;
              primary = true;
              mode = "2880x1920";
            };
            office.enable = false;
          };
          hooks.postswitch.kb = ''
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap us
            ${pkgs.xorg.xmodmap}/bin/xmodmap $HOME/.Xmodmap
          '';
        };
        office = {
          inherit fingerprint;
          config = {
            laptop.enable = false;
            office = {
              enable = true;
              primary = true;
              # mode = "2560x1440";
              mode = "3840x2160";
            };
          };
          hooks.postswitch.kb = ''
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap us
            ${pkgs.xorg.xmodmap}/bin/xmodmap $HOME/.Xmodmap_split
          '';
        };
        home = {
          inherit fingerprint;
          config = {
            laptop.enable = false;
            home = {
              enable = true;
              primary = true;
              # mode = "2560x1440";
              mode = "3840x2160";
            };
          };
          hooks.postswitch.kb = ''
            ${pkgs.xorg.setxkbmap}/bin/setxkbmap us
            ${pkgs.xorg.xmodmap}/bin/xmodmap $HOME/.Xmodmap
          '';
        };
      };
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ hplipWithPlugin gutenprint gutenprintBin ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    power-profiles-daemon.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    openssh.enable = true;
    blueman.enable = true;
    fwupd.enable = true;
    fprintd.enable = true;
    udev.extraRules = ''
      # Allow video group users to manipulate backlight
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"

      # Trigger autorandr on display changes
      # TODO: need to fix cycle using epoch mtime in autorandr
      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.autorandr}/bin/autorandr --change"
    '';
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services = {
      i3lock.enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      extraPackages = with pkgs; [ docker-credential-helpers ];
      daemon.settings = {
        userland-proxy = false;
      };
    };
  };
  
  users = {
    defaultUserShell = "/etc/profiles/per-user/m0ar/bin/zsh";
    users.m0ar = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "docker"
        "video"
      ];
    };
  };

  programs = {
    firefox.enable = true;
    nix-ld = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    dconf
    linux-firmware
    pciutils
    hwdata
    lshw
    usbutils
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}
