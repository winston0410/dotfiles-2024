{ inputs, lib, config, pkgs, isDarwin, ... }: {
  xdg.enable = true;
  xdg.mime.enable = !isDarwin;
  xdg.mimeApps = {
    enable = !isDarwin;
    associations.added = {
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
      "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";

      "text/javascript" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/plain" = "nvim.desktop";
      "text/x-log" = "nvim.desktop";
      "text/x-makefile" = "nvim.desktop";
      "text/x-c++hdr" = "nvim.desktop";
      "text/x-c++src" = "nvim.desktop";
      "text/x-chdr" = "nvim.desktop";
      "text/x-csrc" = "nvim.desktop";
      "text/x-java" = "nvim.desktop";
      "text/x-moc" = "nvim.desktop";
      "text/x-pascal" = "nvim.desktop";
      "text/x-tcl" = "nvim.desktop";
      "text/x-tex" = "nvim.desktop";
      "text/xml" = "nvim.desktop";
      "text/x-c" = "nvim.desktop";
      "text/x-c++" = "nvim.desktop";

      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
    associations.removed = { };
    defaultApplications = {
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    };
  };
  xdg.userDirs = {
    enable = !isDarwin;
    desktop = "${config.home.homeDirectory}/Desktop";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    music = "${config.home.homeDirectory}/Music";
    videos = "${config.home.homeDirectory}/Videos";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
    };
  };

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      exec = "wezterm start -- nvim %F";
      terminal = false;
      type = "Application";
      categories = [ "Development" ];
    };
  };

  # REF https://github.com/TLATER/dotfiles/blob/master/home-config/config/xdg-settings.nix
  # REF nix run github:b3nj5m1n/xdg-ninja
  # REF https://wiki.archlinux.org/title/XDG_Base_Directory
  home.sessionVariables = {
    LESSKEY = "${config.xdg.cacheHome}/less/key";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    PYLINTHOME = "${config.xdg.cacheHome}/pylint";
    CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    MAILCAPS = "${config.xdg.configHome}/mailcap";
    IPYTHONDIR = "${config.xdg.dataHome}/ipython";
    JUPYTER_CONFIG_DIR = "${config.xdg.dataHome}/ipython";
    RLWRAP_HOME = "${config.xdg.dataHome}/rlwrap";
    CUDA_CACHE_PATH = "${config.xdg.dataHome}/.nv";
    GRADLE_USER_HOME = "${config.xdg.cacheHome}/gradle";
    FFMPEG_DATADIR = "${config.xdg.configHome}/ffmpeg";
    FCEUX_HOME = "${config.xdg.configHome}/fceux";
    REDISCLI_HISTFILE = "${config.xdg.dataHome}/redis/rediscli_history";
    REDISCLI_RCFILE = "${config.xdg.configHome}/redis/redisclirc";
    RUFF_CACHE_DIR = "${config.xdg.cacheHome}/ruff";
    SOLARGRAPH_CACHE = "${config.xdg.cacheHome}/solargraph";
    SQLITE_HISTORY = "${config.xdg.dataHome}/sqlite_history";
    W3M_DIR = "${config.xdg.stateHome}/w3m";
    WAKATIME_HOME = "${config.xdg.configHome}/wakatime";
    WGETRC = "${config.xdg.configHome}/wgetrc";
    XINITRC = "${config.xdg.configHome}/X11/xinitrc";
    XSERVERRC = "${config.xdg.configHome}/X11/xserverrc";
  };
  home.shellAliases = {
    nvidia-settings =
      "nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings";
  };
}
