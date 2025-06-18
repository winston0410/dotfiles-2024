{ inputs, lib, config, pkgs, system, ... }: {
  programs.firefox = {
    enable = true;
    package = if pkgs.stdenv.isLinux then
      pkgs.firefox
      # (pkgs.firefox.override {
      #   nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
      # })
    else
      pkgs.firefox-bin.overrideAttrs
      (_: rec { override = _: pkgs.firefox-bin; });
    nativeMessagingHosts = [ ] ++ (lib.lists.optionals pkgs.stdenv.isLinux
      [ pkgs.gnome-browser-connector ]);
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
          "addon@darkreader.org"
        ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = { default_area = "navbar"; };
        "446900e4-71c2-419f-a6a7-df9c091e268b" = { default_area = "navbar"; };
        "addon@darkreader.org" = { default_area = "navbar"; };
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
          # TODO examine whether we should add the following config for privacy
          # https://wiki.mozilla.org/Privacy/Privacy_Task_Force/firefox_about_config_privacy_tweeks
        };
        search = {
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];

              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nix" ];
            };
          };
        };
        extensions = {
          packages = with pkgs; [
            nur.repos.rycee.firefox-addons.bitwarden
            nur.repos.rycee.firefox-addons.ublock-origin
          ];
        };
      };
    };
  };
}
