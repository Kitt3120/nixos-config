{ pkgs, ... }:

{
  # TODO: Remove workaround
  # Thanks to IncredibleLaser! https://github.com/NixOS/nixpkgs/issues/444209#issuecomment-3315031496
  hardware.ckb-next = {
    enable = true;
    package = pkgs.ckb-next.overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DUSE_DBUS_MENU=0" ];
    });
  };
}
