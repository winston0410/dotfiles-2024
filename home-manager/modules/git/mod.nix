{ inputs, lib, config, pkgs, isDarwin, ... }: {
  programs.git.enable = true;
  programs.git.delta.enable = true;
  # programs.git.package = pkgs.git.override { withLibsecret = !isDarwin; };

  programs.git.extraConfig = {
    pull = { ff = false; };
    # REF https://stackoverflow.com/a/61920529
    http = { postBuffer = 524288000; };

    init = { defaultBranch = "main"; };

    user = {
      email = "hugosum.dev@protonmail.com";
      name = "John Doe";
    };
    credential = {
      helper = if isDarwin then [
        "osxkeychain"
        "cache --timeout 43200"
        "oauth"
      ] else [
        "cache --timeout 43200"
        "oauth"
      ];
    };
    core = { editor = "nvim"; };

    delta = {
      navigate = true;
      light = false;
    };

    lfs = { enable = true; };

    merge = { conflictstyle = "diff3"; };

    diff = { colorMoved = "default"; };
  };
  home.packages = with pkgs; [ git-credential-oauth ];
}
