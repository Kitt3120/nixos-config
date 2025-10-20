{ ... }:

{
  services.avahi = {
    enable = true;
    publish.enable = true;
    openFirewall = true;
  };
}
