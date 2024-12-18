{ inputs, lib, config, pkgs, ... }: {
  launchd.enable = true;

  launchd.agents = {
    wezterm = {
      enable = true;

      config = {
        LimitLoadToSessionType = "Aqua";
        # need to either use absolute path, or set the PATH env with config.EnvironmentVariables
        ProgramArguments = [ "/Users/hugosum/.nix-profile/bin/wezterm" ];
        ProcessType = "Interactive";
        KeepAlive = true;
      };
    };
  };
}
