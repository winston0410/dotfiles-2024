{ inputs, lib, config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
    };
    nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
    languagePacks = [ "en-GB" ];
    policies = {
      AppAutoUpdate = false;
      FirefoxSuggest = { "SponsoredSuggestions" = false; };
      DisableTelemetry = true;
      HardwareAcceleration = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      # REF https://mozilla.github.io/policy-templates/#extensions
      # NOTE find UUID for each extension in about:debugging#/runtime/this-firefox
      Extensions = {
        Locked = [
          "uBlock0@raymondhill.net"
          # Extension ID for bitwarden
          "446900e4-71c2-419f-a6a7-df9c091e268b"
        ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = { default_area = "navbar"; };
        "446900e4-71c2-419f-a6a7-df9c091e268b" = { default_area = "navbar"; };
      };
      SSLVersionMin = "tls1.2";
    };
    profiles = {
      kghugo = {
        id = 0;
        name = "kghugo";
        isDefault = true;
        settings = {
          # find value from about:config
          "browser.startup.homepage" = "https://sso.28281428.xyz";
          "extensions.pocket.enabled" = false;
          "browser.toolbarbuttons.introduced.pocket-button" = false;
        };
        search = { force = true; };
        # WARN extension will be installed, but not automatically enabled. You have to visit the extension page to enable them individually
        extensions = with pkgs; [
          nur.repos.rycee.firefox-addons.bitwarden
          nur.repos.rycee.firefox-addons.ublock-origin
        ];
      };
    };
  };
}
