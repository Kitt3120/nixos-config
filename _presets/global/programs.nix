{ config, pkgs, ... }:

{
  imports = [
    ../../programs/appimage-run.nix
    ../../programs/aria2.nix
    ../../programs/bcachefs-tools.nix
    ../../programs/btop.nix
    ../../programs/btrfs-progs.nix
    ../../programs/cpupower.nix
    ../../programs/cryptsetup.nix
    ../../programs/dfc.nix
    ../../programs/dig.nix
    ../../programs/exfatprogs.nix
    ../../programs/fdisk.nix
    ../../programs/ffmpeg.nix
    ../../programs/fish.nix
    ../../programs/fuse3.nix
    ../../programs/gdisk.nix
    ../../programs/gh.nix
    ../../programs/git.nix
    ../../programs/gnu-coreutils-full.nix
    ../../programs/gnumake.nix
    ../../programs/gnutar.nix
    ../../programs/htop.nix
    ../../programs/i2c-tools.nix
    ../../programs/java.nix
    ../../programs/jq.nix
    ../../programs/killall.nix
    ../../programs/llvm.nix
    ../../programs/lm_sensors.nix
    ../../programs/lshw.nix
    ../../programs/lvm2.nix
    ../../programs/mail.nix
    ../../programs/ncdu.nix
    ../../programs/neofetch.nix
    ../../programs/nh.nix
    ../../programs/nix-alien.nix
    ../../programs/nix-index.nix
    ../../programs/nix-ld.nix
    ../../programs/nix-output-monitor.nix
    ../../programs/nix-prefetch-github.nix
    ../../programs/nixfmt.nix
    ../../programs/nmap.nix
    ../../programs/ntfs3g.nix
    ../../programs/nvd.nix
    ../../programs/openssl.nix
    ../../programs/parallel.nix
    ../../programs/parted.nix
    ../../programs/pciutils.nix
    ../../programs/pigz.nix
    ../../programs/pkg-config.nix
    ../../programs/pkgconf.nix
    ../../programs/python3.nix
    ../../programs/rsync.nix
    ../../programs/rustup.nix
    ../../programs/screen.nix
    ../../programs/scrub.nix
    ../../programs/speedtest-cli.nix
    ../../programs/thefuck.nix
    ../../programs/tldr.nix
    ../../programs/unzip.nix
    ../../programs/usbutils.nix
    ../../programs/uwufetch.nix
    ../../programs/vim.nix
    ../../programs/wget.nix
    ../../programs/wine-staging.nix
    ../../programs/xfsprogs.nix
    ../../programs/xz.nix
    ../../programs/yt-dlp.nix
    ../../programs/zip.nix
    ../../programs/zoxide.nix
    ../../programs/zstd.nix
  ];
}
