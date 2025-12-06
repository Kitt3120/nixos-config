{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ ];

    allowedUDPPorts = [
      19132 # Geyser
    ];

    # MC Servers
    allowedTCPPortRanges = [
      {
        from = 25565;
        to = 25599;
      }
    ];

    # MC Servers
    allowedUDPPortRanges = [
      {
        from = 25565;
        to = 25599;
      }
    ];
  };
}
