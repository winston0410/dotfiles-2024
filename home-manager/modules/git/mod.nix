{ inputs, lib, config, pkgs, ... }: {
  programs.git.enable = true;
  # programs.git.package = pkgs.git.override { withLibsecret = !isDarwin; };

  programs.git.extraConfig = {
    pull = { ff = true; };
    # REF https://stackoverflow.com/a/61920529
    http = { postBuffer = 524288000; };

    init = { defaultBranch = "main"; };

    user = {
      email = "hugosum.dev@protonmail.com";
      name = "nobody";
    };
    credential = {
      # REF https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/configuration.md#credentialcredentialstore
      credentialStore = "gpg";
      cacheOptions = 86400;
      "https://forgejo.28281428.xyz" = { provider = "auto"; };
      "https://dev.azure.com" = { provider = "auto"; useHttpPath = true; };
      helper = [ "${pkgs.git-credential-manager}/bin/git-credential-manager" ];
    };
    core = { editor = "nvim"; };

    delta = {
      navigate = true;
      light = false;
    };

    lfs = { enable = true; };

    merge = {
      tool = "nvimdiff";
      conflictStyle = "zdiff3";
    };
    mergetool = {
      prompt = false;
      nvimdiff = { layout = "@LOCAL, REMOTE"; };
    };

    diff = {
      tool = "nvimdiff";
      conflictStyle = "zdiff3";
    };
    difftool = {
      prompt = false;
      nvimdiff = { layout = "@LOCAL, REMOTE"; };
    };

    alias = {
      diffview = "!nvim -c DiffviewOpen";
      # mergetool = "!nvim -c DiffviewOpen";
      # difftool = "!nvim -c DiffviewOpen";
    };
  };
  home.packages = with pkgs; [ git-credential-manager ];
}
