{ ... }:

{
  programs.appimage = {
    enable = true;
    binfmt = true;

    # extra packages to include in the AppImage runtime environment needed by some AppImages
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          icu # needed by dotnet apps
        ];
    };
  };
}
