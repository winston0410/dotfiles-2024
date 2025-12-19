{ inputs, unstable, lib, config, pkgs,  ... }: {
  home.packages = [
    # FIXME wait for this to resolve https://github.com/NixOS/nixpkgs/issues/339576
    pkgs.bitwarden-cli
  ];
}
