{ ... }:

{
  services.avahi = {
    enable = true;
    settings.publish.disable-publishing = false;
    openFirewall = true;
    nssmdns4 = true;
    nssmdns6 = true;
  };
}
