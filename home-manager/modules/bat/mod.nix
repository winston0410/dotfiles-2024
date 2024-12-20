{ inputs, lib, config, pkgs, ... }: {
  home.shellAliases = { cat = "bat"; };

  home.packages = with pkgs; [ bat ];

  xdg.configFile = {
    "bat/config" = { source = ./config; };
    "bat/themes" = { source = ./themes; };
  };

  home.activation.refresh-cache = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # Rebuild cache to ensure theme can be found.
    run --quiet ${pkgs.bat}/bin/bat cache --build
  '';
}
