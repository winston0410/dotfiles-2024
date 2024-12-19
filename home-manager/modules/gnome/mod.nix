{ inputs, lib, config, pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-B-MB";
      package = pkgs.tokyonight-gtk-theme;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.5;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };
    "org/gnome/desktop/datetime" = { automatic-timezone = true; };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "Vitals@CoreCoding.com"
        "wiggle@mechtifs"
        "status-icons@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "app-hider@lynith.dev"
        "wifiqrcode@glerro.pm.me"
        "gsconnect@andyholmes.github.io"
      ];

      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "org.wezfurlong.wezterm.desktop"
      ];
    };
    "org/gnome/shell/extensions/app-hider" = {
      hidden-apps = [ "vim.desktop" ];
    };
    "org/gnome/mutter" = { dynamic-workspaces = true; };
  };

  home.packages = with pkgs; [
    nautilus
    gnomeExtensions.vitals
    gnomeExtensions.wiggle
    gnomeExtensions.status-icons
    gnomeExtensions.user-themes
    gnomeExtensions.paperwm
    gnomeExtensions.gsconnect
    gnomeExtensions.app-hider
    gnomeExtensions.wifi-qrcode
    # weather-oclock requires gnome-weather
    gnomeExtensions.weather-oclock
    gnome-weather
  ];
}
