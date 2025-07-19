# Made by Sicheng-Pan (Macronova) (https://github.com/Sicheng-Pan) for nixpkgs repo here: https://github.com/NixOS/nixpkgs/pull/334984
# Thank you so much for this!

# TODO: Switch to nixpkgs version
{
  extra-cmake-modules,
  fetchFromGitHub,
  kpackage,
  libplasma,
  lib,
  lz4,
  mkKdeDerivation,
  mpv-unwrapped,
  pkg-config,
  python3,
  qtbase,
  qtmultimedia,
  qtwebchannel,
  qtwebengine,
  qtwebsockets,
}:

let
  version = "ed58dd8b920dbb2bf0859ab64e0b5939b8a32a0e";
in
mkKdeDerivation {
  pname = "wallpaper-engine-kde-plugin";
  version = version;

  src = fetchFromGitHub {
    owner = "catsout";
    repo = "wallpaper-engine-kde-plugin";
    rev = version;
    sha256 = "sha256-ICQLtw+qaOMf0lkqKegp+Dkl7eUgPqKDn8Fj5Osb7eA=";
    fetchSubmodules = true;
  };

  patches = [ ./wallpaper-engine-kde-plugin.patch ];

  extraNativeBuildInputs = [
    kpackage
    pkg-config
    (python3.withPackages (ps: with ps; [ websockets ]))
  ];

  extraBuildInputs = [
    extra-cmake-modules
    libplasma
    lz4
    mpv-unwrapped
  ];

  extraCmakeFlags = [
    (lib.cmakeFeature "QML_LIB" (
      lib.makeSearchPathOutput "out" "lib/qt-6/qml" [
        qtmultimedia
        qtwebchannel
        qtwebengine
        qtwebsockets
      ]
    ))
    (lib.cmakeFeature "Qt6_DIR" "${qtbase}/lib/cmake/Qt6")
  ];

  postInstall = ''
    cd $out/share/plasma/wallpapers/com.github.catsout.wallpaperEngineKde
    chmod +x ./contents/pyext.py
    patchShebangs --build ./contents/pyext.py
    substituteInPlace ./contents/ui/Pyext.qml \
       --replace-fail NIX_STORE_PACKAGE_PATH ${placeholder "out"}
    cd -
  '';

  meta = with lib; {
    description = "KDE wallpaper plugin integrating Wallpaper Engine";
    homepage = "https://github.com/catsout/wallpaper-engine-kde-plugin";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ macronova ];
  };
}
