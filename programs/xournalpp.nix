{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xournalpp ];
}
