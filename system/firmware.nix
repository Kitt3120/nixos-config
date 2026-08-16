{ pkgs, ... }:

let
  mt7927BluetoothFirmware = pkgs.runCommand "mt7927-bluetooth-firmware" { } ''
    install -Dm644 \
      ${
        pkgs.fetchurl {
          url = "https://gitlab.com/jetm/linux-firmware/-/raw/77ad2a92acf2ac3e5ea47432b43d925ff99db909/mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin";
          hash = "sha256-ZpxcmaDFnIXBKF09G4sxkVwtMTQaIkT07dy/1g/7vHY=";
        }
      } \
      $out/lib/firmware/mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin
  '';
in
{
  hardware.enableAllFirmware = true;

  # TODO: Remove when MT7927 Bluetooth firmware is merged upstream into linux-firmware.
  # Temporary workaround until MT7927 Bluetooth firmware lands in linux-firmware.
  hardware.firmware = [
    mt7927BluetoothFirmware
  ];
}
