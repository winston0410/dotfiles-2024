{ inputs, lib, config, pkgs, isDarwin, ... }: {
  programs.git.enable = true;
  programs.git.delta.enable = true;

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
      helper = if isDarwin then
        [
          # "osxkeychain"
          "oauth"
        ]
      else
        [
          "secretservice"
          # "oauth"
        ];
      # if isDarwin then [
      #   "osxkeychain"
      #   # "oauth"
      # ] else [
      #   "secretservice"
      #   # "oauth"
      # ];
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
