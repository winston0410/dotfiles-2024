{ inputs, lib, config, pkgs, system, ... }: {
  programs.chromium.enable = true;
  programs.chromium.package = pkgs.ungoogled-chromium;
  # nativeMessagingHosts = [ pkgs.gnome-browser-connector ];
}
