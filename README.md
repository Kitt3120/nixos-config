# NixOS Configuration

This repository contains a highly modular and abstracted NixOS configuration designed to manage multiple physical devices with shared functionality while maintaining device-specific customizations.

## 🏗️ Architecture Overview

The configuration follows a layered architecture pattern that makes it easy to re-use and maintain parts of the configuration across different devices:

```text
Flake → Base configuration + Device Profile → Presets + Modules + Settings
```

### 1. **Flake (Entry Point)**

- Defines three NixOS configurations for physical devices:
  - `modulosaurus` - Main desktop/workstation
  - `hydra` - Laptop
  - `schweren` - Server
- Each defined NixOS configuration imports 2 files:
  - `configuration.nix` - Base system configuration: Imports home-manager, sops-nix, and hardware-configuration
  - `_profiles/<device>.nix` - Device-specific configuration: Imports everything else
- Uses nixpkgs unstable for the latest packages
- Integrates external inputs like `home-manager`, `sops-nix`, and more

### 2. **Profiles (Device-Specific)**

Each physical device has its own profile directory:

- `_profiles/modulosaurus/`
- `_profiles/hydra/`
- `_profiles/schweren/`

Each profile imports relevant presets and device-specific modules.

### 3. **Presets (Functionality Groups)**

Presets group related functionality by purpose:

- `global.nix` - Core system functionality (always imported)
- `desktop.nix` - Desktop environment and GUI applications
- `development.nix` - Programming tools and IDEs
- `gaming.nix` - Gaming-related software and optimizations
- `media.nix` - Media creation and consumption tools
- `pentesting.nix` - Security testing and analysis tools
- `productivity.nix` - Office and productivity applications
- `social.nix` - Communication and social applications
- Hardware-specific presets: `amd-cpu.nix`, `amd-gpu.nix`, `gpu.nix`

### 4. **Modules**

Individual modules for specific programs, services, or system configurations are organized into:

- `programs/` - Programs (100+)
- `services/` - Daemons, user-space drivers, etc.
- `desktop/` - Desktop environments. Currently, only KDE Plasma, but Hyprland is planned.
- `gpu/` - GPU support
- `networking/` - Network-related stuff, like firewall, VPN, etc.
- `system/` - Low-level system configurations, kernel modules, etc.
- `users/` - User management + global `torben` user
- `virtualization/` - Container and VM setups

## 🎯 Key Benefits of This Architecture

### **Source of Truth**

Because profiles import modules (either via presets or directly), modules are the source of truth for multiple devices. Fixing something or changing a behavior in a module will automatically apply to all devices that use that module, resulting in a consistent environment across devices.

### **Custom Abstractions over nixpkgs modules**

The modular design allows for powerful customizations by defining device-specific settings and/or attribute overrides to existing nixpkgs modules.

#### **Example: OpenRGB on master**

OpenRGB in nixpkgs is currently outdated. The version provided is **2 years** behind OpenRGB's master branch. It's so old that it lacks support for RGB hardware I use. This approach solves this issue: Instead of being stuck with that version, abstracted modules can override nixpkgs versions in those cases:

```nix
# services/openrgb.nix
let
  openrgb-master = pkgs.openrgb-with-all-plugins.overrideAttrs (oldAttrs: rec {
    version = "master";
    src = pkgs.fetchFromGitLab {
      owner = "CalcProgrammer1";
      repo = "OpenRGB";
      rev = "master"; # use master instead of 2 year old release
      sha256 = "...";
    };
    # Custom patches to make current master work
    postPatch = ''
      patchShebangs scripts/build-udev-rules.sh
      # ... additional fixes
    '';
  });
in
#...
```

#### **Example: Per-Device Settings with zramSwap**

Abstracted modules can expose settings that are configured differently per device:

```nix
# In zramSwap.nix

#...

options.settings.zramSwap = {
  enable = lib.mkOption {
  type = lib.types.bool;
  description = "Alias for zramSwap.enable";
  };

  optimiseSysctl = lib.mkOption {
  type = lib.types.bool;
  description = "Applies sysctl settings to optimize zram swap usage. Reference: https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram";
  };

  priority = lib.mkOption {
  type = lib.types.int;
  description = "Alias for zramSwap.priority";
  };

  memoryPercent = lib.mkOption {
  type = lib.types.int;
  description = "Alias for zramSwap.memoryPercent";
  };

  algorithm = lib.mkOption {
  type = lib.types.str;
  description = "Alias for zramSwap.algorithm";
  };
};
#...
```

```nix
# In device-specific settings.nix
settings = {
  zramSwap = {
    enable = true;
    optimiseSysctl = true;
    algorithm = "zstd";
    priority = 5;
    memoryPercent = 50;
  };
};
```

This allows the same module to be used across devices with device-appropriate configurations.

### **Reusable Functions**

Custom functions eliminate code duplication.

#### **Minecraft Server Generator**

The `mkMinecraftServer` function creates complete server setups:

- Automatic download and hash verification of jar files
- Systemd service generation
- CLI management script
- User-specific home-manager integration

#### **User Mapping**

Utility function `mapAllUsersToSet` can be used to apply home-manager configurations to all users.

Example:

```nix
home-manager.users = config.mapAllUsersToSet (user: {
  "${user}".xdg.configFile."kitty/kitty.conf".text = ''
      term xterm-256color
      shell_integration enabled
      confirm_os_window_close -1
    '';
  }
);
```

This sets `~/.config/kitty/kitty.conf` for all users registered to the `allUsers` setting.

### **Flexible Device Profiles**

Each device can:

- Import only relevant presets (example: server doesn't need gaming preset)
- Import additional modules for device-specific functionality
- Override device-specific settings
- Maintain device-specific secrets

### **Hardware Abstraction**

Hardware-specific presets (`amd-cpu.nix`, `amd-gpu.nix`) can be mixed and matched:

- `modulosaurus` and `hydra`: AMD CPU + AMD GPU
- `schweren`: AMD CPU only (server, no GPU needed)

## 🔐 Secrets Management

Uses [sops-nix](https://github.com/Mic92/sops-nix) for secure secrets handling:

- **Shared secrets**: Common secrets used across devices
- **Device-specific secrets**: Secrets that differ per device
- **Age encryption**: sops uses age encryption under the hood
- **Granular access**: Device-specific secrets can only be decrypted by the corresponding device. Secrets are decrypted at runtime, so no sensitive data is stored in the Nix store.

Example defining a shared secret:

```nix
  sops.secrets."your/secret" = { };
```

Example defining a device-specific secret:

```nix
sops.secrets."your/secret" = {
  sopsFile = config.settings.sops.device-secrets; # this variable is automatically set to the device-specific secrets file through the device profile's settings.nix
};
```

## 🛠️ Development Workflow

### **Adding New Software**

1. Create module in appropriate directory (`programs/`, `services/`, etc.)
2. Add module to relevant preset(s) or directly to device profile

### **Adding a New Device**

1. Create new profile directory: `_profiles/new-device/`
2. Create device-specific modules (hostname, settings, etc.)
3. Import relevant modules and presets in `_profiles/new-device.nix`
4. Add configuration to `flake.nix`
5. Create device-specific secrets file
6. Generate age key on new device using `age-keygen`
7. Register device-specific secrets and public key in `.sops.yaml`

## 🚀 Usage

### **Building and Switching**

Run

```bash
./switch.sh
```

This will install the configuration to `/etc/nixos`. Even though this is not needed with flakes anymore, we still do it this way. Your old config will be backed up to `/tmp`. Permissions will be set so that no one except root can read the `/etc/nixos` directory. While switching, `nixos-output-monitor` is used to give a nice overview of the process.

### **Updating Flake Inputs**

Nothing special here, just run

```bash
nix flake update
```

as usual.
