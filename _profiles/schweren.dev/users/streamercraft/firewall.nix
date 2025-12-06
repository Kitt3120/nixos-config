{ ... }:

{
  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 25565;
        to = 25599;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 25565;
        to = 25599;
      }
    ];
  };
}
