{ inputs, lib, config, pkgs, firefox-addons, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
    };
    nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
    languagePacks = [ "en-GB" ];
    profiles = {
      kghugo = {
        id = 0;
        name = "kghugo";
        isDefault = true;
        extensions = [ ];
      };
    };
  };
}
