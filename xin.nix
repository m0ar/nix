{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./xin-hardware.nix
  ];

  # nixpkgs = {
  #   config = {
  #     allowUnfree = true;
  #   };
  # };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
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
    initrd.luks.devices = {
      "cryptlvm" = {
        device = "/dev/nvme0n1p6";
        preLVM = true;
      };
    };
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev"; 
        useOSProber = true;
        copyKernels = true;
        configurationLimit = 2;
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
      AllowHybridSleep
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
      wifi.backend = "iwd";
    };
  };

  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  services = {
    dbus = {
      enable = true;
      packages = [  pkgs.dconf ];
    };
    # kmscon = {
    #   enable = true;
    #   fonts = [{ name = "Fira Code"; package = pkgs.fira-code; }];
    #   hwRender = true;
    # };

    xserver = {
      enable = true;
      displayManager.startx.enable = true;

      xkb = {
        layout = "us";
        options = "eurosign:e,caps:escape";
      };
    };
    printing.enable = true;
    power-profiles-daemon.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    fwupd.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = "/etc/profiles/per-user/m0ar/bin/zsh";
    users.m0ar = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
      ];
    };

  };

  # home-manager = {
  #   users.m0ar = m0ar;
  #   # useGlobalPkgs = true;
  #   useUserPackages = true;
  #   extraSpecialArgs = { inherit inputs; };
  # };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    dconf
    linux-firmware
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


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
