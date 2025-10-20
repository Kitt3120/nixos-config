{ config, pkgs, ... }:

{
  imports = [
    ../programs/adb.nix
    ../programs/delta.nix
    ../programs/gh.nix
    ../programs/gradle.nix
    ../programs/java.nix
    ../programs/jetbrains-toolbox.nix
    ../programs/llvm.nix
    ../programs/maven.nix
    ../programs/python3.nix
    ../programs/rustup.nix
    ../programs/sqlite.nix
    ../programs/vscode.nix
  ];
}
