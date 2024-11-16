{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virtiofsd
    libguestfs
    guestfs-tools
  ];

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}" = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };

      xdg.configFile."libvirt/qemu.conf".text = ''
        # Adapted from /var/lib/libvirt/qemu.conf
        # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
        nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]'';
    };
  });
}
