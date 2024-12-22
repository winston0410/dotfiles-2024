{ inputs, lib, config, pkgs, ... }: {
  gtk = {
    enable = true;
    # these are somehow not good enough
    # theme = {
    # name = "Tokyonight-Dark-B-MB";
    # package = pkgs.tokyonight-gtk-theme;
    # name = "WhiteSur";
    # package = pkgs.whitesur-gtk-theme;
    # };
    iconTheme = {
      name = "WhiteSur-nord";
      package = (pkgs.whitesur-icon-theme.override {
        boldPanelIcons = true;
        themeVariants = [ "nord" "default" "pink" ];
      });
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-hinting = "full";
      font-antialiasing = "rgba";
      monospace-font-name = "0xProto Nerd Font Mono";
      # document-font-name = "";
      # font-name = "";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.5;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
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
        "weatheroclock@CleoMenezesJr.github.io"
        "gsconnect@andyholmes.github.io"
        "quick-settings-audio-panel@rayzeq.github.io"
        "clipboard-indicator@tudmotu.com"
        "blur-my-shell@aunetx"
        "AlphabeticalAppGrid@stuarthayhurst"
      ];

      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "org.wezfurlong.wezterm.desktop"
        "thunderbird.desktop"
      ];
    };
    "org/gnome/shell/extensions/quick-settings-audio-panel" = {
      always-show-input-slider = true;
    };
    "org/gnome/shell/extensions/app-hider" = {
      hidden-apps =
        [ "vim.desktop" "org.gnome.Weather.desktop" "nvim.desktop" ];
    };
    "org/gnome/shell/extensions/vitals" = { show-gpu = true; };
    "org/gnome/shell/extensions/clipboard-indicator" = { history-size = 25; };
    "org/gnome/mutter" = { dynamic-workspaces = true; };
  };

  home.packages = with pkgs; [
    nautilus
    gnomeExtensions.vitals
    gnomeExtensions.wiggle
    gnomeExtensions.status-icons
    gnomeExtensions.user-themes
    gnomeExtensions.paperwm
    gnomeExtensions.app-hider
    gnomeExtensions.wifi-qrcode
    # weather-oclock requires gnome-weather
    gnomeExtensions.weather-oclock
    gnome-weather
    # gnome-clocks provide clock for multiple timezone
    gnome-clocks
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.blur-my-shell
    gnomeExtensions.alphabetical-app-grid
    # image viewer
    eog
    # video viewer
    totem
    gnome-font-viewer
  ];

  xdg.configFile = {
    "ibus/rime/default.custom.yaml" = { source = ./default.custom.yaml; };
  };
}
