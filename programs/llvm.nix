{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    llvmPackages.openmp
    llvmPackages.mlir
    llvmPackages.lldb-manpages
    llvmPackages.libunwind
    llvmPackages.libcxxStdenv
    llvmPackages.libcxxClang
    llvmPackages.compiler-rt-libc
    llvmPackages.clangUseLLVM
    llvmPackages.bintools
    libllvm
  ];
}
