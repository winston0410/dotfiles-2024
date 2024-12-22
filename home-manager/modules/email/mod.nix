{ inputs, lib, config, pkgs, system, isDarwin, ... }: {
  # TODO https://github.com/nix-community/home-manager/issues/3019
  # Automate this in the future
  # home.packages = with pkgs;
  #   [
  #     # for using protonmail with email client
  #     protonmail-bridge
  #   ];

  programs.thunderbird = {
    enable = true;
    profiles = { };
  };

  accounts.email.accounts = {
    kghugo2000_at_protonmail_dot_com = {
      primary = true;
      address = "kghugo2000@protonmail.com";
      realName = "Hugo Sum";
      userName = "kghugo2000@protonmail.com";

      thunderbird.enable = true;
    };
    hugosum_dot_dev_at_protonmail_dot_com = {
      address = "hugosum.dev@protonmail.com";
      realName = "Hugo Sum";
      userName = "hugosum.dev@protonmail.com";

      thunderbird.enable = true;
    };
  };
}
