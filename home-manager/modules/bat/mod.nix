{ inputs, lib, config, pkgs, ... }: {
  home.shellAliases = { cat = "bat"; };

  home.packages = with pkgs; [ bat ];

  xdg.configFile = {
    "bat/config" = { source = ./config; };
    "bat/themes" = { source = ./themes; };
  };

  programs.zsh.initExtra = ''
    # Rebuild cache to ensure theme can be found.
    # Use a subshell to prevent any output
    # REF https://stackoverflow.com/a/51061398
    (bat cache --build > /dev/null 2>&1 &)
  '';
}
