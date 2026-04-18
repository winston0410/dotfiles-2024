{ inputs, lib, config, pkgs, ... }: {
  home.file = {
    ".claude/keybindings.json" = {
      source = ./keybindings.json;
    };
  };
}
