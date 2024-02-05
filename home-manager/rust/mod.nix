{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; let 
    toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;
  in[
    # NOTE Cannot install rustup with rust-overlay. Therefore we cannot use this for building lambda function
    toolchain
  ];
}
