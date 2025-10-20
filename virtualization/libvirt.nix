{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  boot.extraModprobeConfig =
    if config.hardware.cpu.intel.updateMicrocode == true then
      "options kvm_amd nested=1"
    else if config.hardware.cpu.amd.updateMicrocode == true then
      "options kvm_intel nested=1"
    else
      "";

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virtiofsd
    libguestfs
    guestfs-tools
  ];

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}" = {
      xdg.configFile."libvirt/qemu.conf".text = ''
        # Adapted from /var/lib/libvirt/qemu.conf
        # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
        nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
      '';
    };
  });

  # NixOS firewall previously allowed traffic from guests to the hypervisor.
  # That traffic was bypassing the firewall.
  # That has been fixed and now the firewall blocks all traffic from guests to the hypervisor.
  # This trusts the virtual interface, so that the communication works again, for example for DHCP.
  # This is hardcoded to virbr0 for now.
  # I might add a device-specific option if needed later.
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
