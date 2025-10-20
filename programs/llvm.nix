{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    llvmPackages.openmp
    llvmPackages.mlir
    llvmPackages.lldb-manpages
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
