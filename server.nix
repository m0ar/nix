{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Taken from https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/nixos/configuration.nix
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      # nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  fileSystems = {
    "/".label = "nixos-root";
    # Create and mount ZFS pool
    # Note: You should create the pool manually before applying this config
    # Example: zpool create naspool mirror /dev/sdb /dev/sdc
    # "/mnt/naspool" = {
    #   device = "naspool";
    #   fsType = "zfs";
    # };
  };

  boot = {
    # We need no bootloader, because we aren't booting yet
    loader.grub.enable = false;
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
  };

  packages = with pkgs; [
    virt-manager
    qemu
    OVMF
    btop
  ];
  
  networking = {
    hostName = "nixos-server";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };

  # TODO: setup nginx for externally exposed tools

  users.users = {
    m0ar = {
      initialPassword = "m0ar";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        (builtins.readFile /home/m0ar/.ssh/id_rsa.pub)
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "libvirtd" ];
    };
  };

  services = {
    zfs = {
      enable = true;
      autoSnapshot.enable = true;
      autoScrub.enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    prometheus = {
      enable = true;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
        };
      };
    };

    grafana = {
      enable = true;
      addr = "0.0.0.0";
      domain = "nas.local";
    };

    # SMART monitoring for drives
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        mail = {
          enable = true;
          mail.recipient = "edvard@hubinette.me";
        };
      };
    };
  };
}
