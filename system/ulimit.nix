{ ... }:

{
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "nofile";
      type = "-";
      value = "524288"; # https://github.com/lutris/docs/blob/master/HowToEsync.md
    }
  ];
}
