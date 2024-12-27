{ inputs, lib, config, pkgs, isDarwin, ... }: {
  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = !isDarwin;
    associations.added = { };
    associations.removed = { };
    defaultApplications = { };
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

  # REF https://github.com/TLATER/dotfiles/blob/master/home-config/config/xdg-settings.nix
  home.sessionVariables = {
    LESSKEY = "${config.xdg.cacheHome}/less/key";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
    PYLINTHOME = "${config.xdg.cacheHome}/pylint";
    CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    MAILCAPS = "${config.xdg.configHome}/mailcap";
    IPYTHONDIR = "${config.xdg.dataHome}/ipython";
    JUPYTER_CONFIG_DIR = "${config.xdg.dataHome}/ipython";
    HISTFILE = "${config.xdg.dataHome}/histfile";
    RLWRAP_HOME = "${config.xdg.dataHome}/rlwrap";
    CUDA_CACHE_PATH = "${config.xdg.dataHome}/cuda";
    GRADLE_USER_HOME = "${config.xdg.cacheHome}/gradle";
  };
}
