{ inputs, lib, config, pkgs, ... }: {
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    font = {
      name = "Inter";
      package = pkgs.inter;
    };
    # these are somehow not good enough
    # theme = {
    # name = "Tokyonight-Dark-B-MB";
    # package = pkgs.tokyonight-gtk-theme;
    # name = "WhiteSur";
    # package = (pkgs.whitesur-gtk-theme.override {
    #
    # });
    # };
    iconTheme = {
      name = "WhiteSur";
      package = (pkgs.whitesur-icon-theme.override {
        boldPanelIcons = true;
        themeVariants = [ "default" ];
      });
    };
    cursorTheme = {
      # name = "MacOS-cursor";
      # package = pkgs.apple-cursor;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      # only a set of size can be used
      # REF https://linux-tips.com/t/setting-cursor-size-in-gnome/835
      size = 48;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri =
        "file:///home/kghugo/.config/gtk-4.0/wallpapers/stardust-dragon.jpg";
      picture-uri-dark =
        "file:///home/kghugo/.config/gtk-4.0/wallpapers/shooting-quasar-dragon.jpg";
    };
    "org/gnome/desktop/interface" = {
      font-hinting = "full";
      font-antialiasing = "rgba";
      monospace-font-name = "0xProto Nerd Font Mono";
      document-font-name = "Inter";
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
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Ctrl><Super>s" ];
    };
    "org/gnome/shell/extensions/quick-settings-audio-panel" = {
      always-show-input-slider = true;
    };
    "org/gnome/shell/extensions/app-hider" = {
      hidden-apps = [
        "vim.desktop"
        "org.gnome.Weather.desktop"
        "nvim.desktop"
        "protontricks.desktop"
        "Proton Hotfix.desktop"
        "Steam Linux Runtime 1.0 (scout).desktop"
        "Steam Linux Runtime 2.0 (soldier).desktop"
        "Steam Linux Runtime 3.0 (sniper).desktop"
      ];
    };
    "org/gnome/shell/extensions/vitals" = { show-gpu = true; };
    "org/gnome/shell/extensions/clipboard-indicator" = { history-size = 25; };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      experimental-features =
        [ "variable-refresh-rate" "scale-monitor-framebuffer" ];
    };
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
    # calendar
    gnome-calendar
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
    gnome-tecla
    gnome-maps
    gnome-calculator
    gnome-characters
    gnome-disk-utility
    # document viewer
    papers
    # disk usage viewer
    baobab
    # secret manager
    seahorse
  ];

  xdg.configFile = {
    "ibus/rime/default.custom.yaml" = { source = ./default.custom.yaml; };
    "gtk-4.0/wallpapers" = { source = ./wallpapers; };
  };
}
