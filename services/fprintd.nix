{ ... }:

{
  services.fprintd.enable = true;

  # Fixes SDDM REQUIRING fingerprint authentication in addition to password
  security.pam.services.login.fprintAuth = false;
}
