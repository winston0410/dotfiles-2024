{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = [ unstable.gemini-cli ];
  # home.file = {
  #   ".gemini/settings.json" = { source = ./settings.json; };
  # };
}
