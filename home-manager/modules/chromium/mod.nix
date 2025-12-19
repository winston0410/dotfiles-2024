{ inputs, lib, config, pkgs,  ... }: {
  programs.chromium.enable = true;
  programs.chromium.package = pkgs.ungoogled-chromium;
  # nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
}
