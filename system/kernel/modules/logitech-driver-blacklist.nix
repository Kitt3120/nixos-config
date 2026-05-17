# The newly introduced logitech driver in Kernel 6.19 causes issues with the Logitech G 502 X Plus
# and some other mice.
# I disable it here until the driver has been improved.
# Previous behaviour with the generic driver has been good for years.

{ ... }:

{
  boot.blacklistedKernelModules = [ "hid_logitech_dj" ];
}
