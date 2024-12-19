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
        search = { force = true; };
        # WARN extension will be installed, but not automatically enabled. You have to visit the extension page to enable them individually
        extensions = [ firefox-addons.bitwarden firefox-addons.ublock-origin ];
      };
    };
  };
}
