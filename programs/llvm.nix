{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    llvmPackages.openmp
    llvmPackages.mlir
    #llvmPackages.lldb-manpages # TODO: Enable again when fixed
    llvmPackages.libunwind
    llvmPackages.libcxxStdenv
    llvmPackages.libcxxClang
    llvmPackages.libclc
    llvmPackages.compiler-rt-libc
    llvmPackages.clangUseLLVM
    llvmPackages.bintools
    libllvm
  ];
}
