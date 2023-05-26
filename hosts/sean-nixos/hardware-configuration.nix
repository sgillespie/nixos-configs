{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "nvidia_drm.modeset=1" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

  fileSystems."/blockchain" =
    { device = "/dev/disk/by-label/blockchain";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; } ];

  boot.initrd.luks = {
    yubikeySupport = true;
    
    devices."encrypted-home" = {
      device = "/dev/disk/by-label/luks";
      
      yubikey = {
        slot = 2;
        twoFactor = false;
        gracePeriod = 300;
        keyLength = 64;
        saltLength = 16;
        
        storage = {
          device = "/dev/disk/by-label/BOOT";
          fsType = "vfat";
          path = "/crypt-storage/default";
        };
      };
    };
  };
    
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
