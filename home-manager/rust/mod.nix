{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; let 
    toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;
  in[
    toolchain
  ];
}
