{ inputs, lib, config, pkgs, ... }: {
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
    core = { editor = "nvim"; };

    delta = {
      navigate = true;
      light = false;
    };

    lfs = { enable = true; };

    merge = { conflictstyle = "diff3"; };

    diff = { colorMoved = "default"; };
  };
  programs.git-credential-oauth.enable = true;
}
