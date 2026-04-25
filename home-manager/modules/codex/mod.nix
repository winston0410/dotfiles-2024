{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = [ unstable.codex unstable.codex-acp ];
  home.file = {
    ".codex/config.toml" = { source = ./config.toml; };
  };
}
