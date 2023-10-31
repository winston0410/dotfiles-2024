{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
    launchd.enable = true;

    launchd.agents = {
      startWezterm = {
        enable = true;
        config = {
          ProgramArguments = [ "wezterm" ];
          LaunchOnlyOnce = true;
          ProcessType = "Interactive";
        };
      };
    };
}
