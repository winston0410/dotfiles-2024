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

    delta = {
      navigate = true;
      light = false;
    };

    merge = { conflictstyle = "diff3"; };

    diff = { colorMoved = "default"; };
  };
}
