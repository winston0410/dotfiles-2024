{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = [ unstable.codex ];
}
