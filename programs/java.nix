{ pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.jdk; # Set to same as first Java below
  };

  environment.systemPackages = with pkgs; [
    # First option is default Java
    jdk
    jdk25
    jdk21
    jdk17
    jdk8
  ];

  environment.variables = {
    JAVA_HOME = "${pkgs.jdk}";
    JAVA_LATEST_HOME = "${pkgs.jdk}";
    JAVA_25_HOME = "${pkgs.jdk25}";
    JAVA_21_HOME = "${pkgs.jdk21}";
    JAVA_17_HOME = "${pkgs.jdk17}";
    JAVA_8_HOME = "${pkgs.jdk8}";
  };
}
