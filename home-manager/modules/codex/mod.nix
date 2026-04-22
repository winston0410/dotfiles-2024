{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = [ unstable.codex ];
  home.file = {
    ".codex/config.toml" = { source = ./config.toml; };
  };
}
