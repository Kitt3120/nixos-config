{
  config,
  pkgs,
  lib,
  ...
}:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  boot.extraModprobeConfig =
    if config.hardware.cpu.intel.updateMicrocode == "amd" then
      "options kvm_amd nested=1"
    else if config.hardware.cpu.amd.updateMicrocode == "intel" then
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
}
