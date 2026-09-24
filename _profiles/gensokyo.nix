{ ... }:

{
  imports = [
    ../_presets/global.nix

    ../_presets/intel-cpu.nix
    ../_presets/intel-npu.nix
    ../_presets/gpu.nix

    ../_presets/desktop.nix
    ../_presets/development.nix
    ../_presets/gaming.nix
    ../_presets/media.nix
    ../_presets/pentesting.nix
    ../_presets/productivity.nix
    ../_presets/social.nix

    ./gensokyo/hardware-configuration.nix
    ./gensokyo/settings.nix

    ./gensokyo/desktop.nix
    ./gensokyo/hostname.nix
    ./gensokyo/networking.nix
    ./gensokyo/programs.nix
    ./gensokyo/services.nix
    ./gensokyo/system.nix
    ./gensokyo/virtualization.nix
  ];
}
