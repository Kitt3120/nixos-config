{ ... }:

{
  services.avahi = {
    enable = true;
    publish.enable = true;
    openFirewall = true;
    nssmdns4 = true;
    nssmdns6 = true;
  };
}
