{ inputs, lib, config, pkgs, ... }: {
  gtk = {
    enable = true;
    # theme = {
    #   name = "tokyonight";
    #   package = pkgs.tokyonight-gtk-theme;
    # };
  };
  # home.sessionVariables.GTK_THEME = "tokyonight";
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "shutdown";
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };
    "org/gnome/desktop/datetime" = { automatic-timezone = true; };
  };

}
