{ ... }:

{
  # This automatically disables normal sudo.
  # Additionally, the module has a check so that sudo and sudo-rs will never be enabled at the same time.
  security.sudo-rs.enable = true;
}
