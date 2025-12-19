{ inputs, lib, config, pkgs,  ... }: {
  programs.rbw.enable = true;
  programs.rbw.settings = {
    base_url = "https://vaultwarden.28281428.xyz";
    email = "kghugo2000@protonmail.com";
    lock_timeout = 86400;
    pinentry = pkgs.pinentry-gnome3;
  };
}
