{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ noson ];

  networking.firewall.allowedTCPPorts = [
    80
    443
    445
    1400
    1401
    1402
    1403
    1404
    1405
    1406
    1407
    1408
    1409
    1410
    3400
    3401
    3405
    3445
    3500
    4070
    4444
    35382
   ];

  networking.firewall.allowedUDPPorts = [
    136
    137
    138
    139
    1900
    1901
    2869
    5353
    6969
    10243
    10280
    10281
    10282
    10283
    10284
  ];
}