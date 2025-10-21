{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "ahci"
    "thunderbolt"
    "usbhid"
    "uas"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  boot.initrd.luks.devices = {
    "luks-26c4d3b5-8b77-46fe-91b2-b4e48f1d50d5".device =
      "/dev/disk/by-uuid/26c4d3b5-8b77-46fe-91b2-b4e48f1d50d5";

    "luks-4c3a4112-387e-4d1d-a2a8-0c20c19f3555".device =
      "/dev/disk/by-uuid/4c3a4112-387e-4d1d-a2a8-0c20c19f3555";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d4f9d4d7-2f3a-4a8a-b3d6-87bb8d01c733";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C4AA-D2E9";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/media/INvmeWDBlack" = {
    device = "/dev/disk/by-uuid/8fe4853e-a0b7-41d8-a371-80f5aaeee4d9";
    fsType = "xfs";
  };

  fileSystems."/media/ISsdSanDisk" = {
    device = "/dev/disk/by-uuid/567e85b8-931e-49f2-96f5-15af1556f9dd";
    fsType = "xfs";
  };

  fileSystems."/media/ISsdSamsungN" = {
    device = "/dev/disk/by-uuid/763d59b1-cede-4dbe-a864-ae60d9c46e6a";
    fsType = "xfs";
  };

  fileSystems."/media/ISsdSamsungO" = {
    device = "/dev/disk/by-uuid/e3712ce3-87b6-474d-ac90-054bee025743";
    fsType = "xfs";
  };

  fileSystems."/media/EHddSG1" = {
    device = "/dev/disk/by-uuid/1ebba608-94d4-4c49-ae88-55fc8d55e778";
    fsType = "xfs";
  };

  fileSystems."/media/EHddSG2" = {
    device = "/dev/disk/by-uuid/ac66b009-d6ea-44e9-934e-a4dbea596a18";
    fsType = "xfs";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/2056ac77-9564-4552-a74a-d5985ab78def"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp14s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wg0-mullvad.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
