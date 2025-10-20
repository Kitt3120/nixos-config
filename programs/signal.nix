{ pkgs, ... }:

{
  # If signal-desktop starts minimized, edit ~/.config/Signal/ephemeral.json and set "maximized" to true
  environment.systemPackages = with pkgs; [ signal-desktop ];
}
