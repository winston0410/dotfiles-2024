{ inputs, unstable, lib, config, pkgs, system, ... }: {
  home.packages = [
    # FIXME wait for this to resolve https://github.com/NixOS/nixpkgs/issues/339576
    unstable.bitwarden-cli
  ];
}
