{ inputs, lib, config, pkgs, ... }: {
  programs.git.enable = true;

  programs.git.extraConfig = {
    pack = {
      threads = 0;
      sparse = true;
    };
    pull = { ff = true; };
    # REF https://stackoverflow.com/a/61920529
    http = { postBuffer = 524288000; };

    init = { defaultBranch = "main"; };

    user = {
      email = "hugosum.dev@protonmail.com";
      name = "nobody";
    };
    credential = {
      "https://forgejo.28281428.xyz" = { provider = "generic"; };
      # REF https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/configuration.md#credentialcredentialstore
      credentialStore = "cache";
      helper = [
        "${pkgs.git-credential-manager}/bin/git-credential-manager"
        # fallback auth method
        "store"
      ];
    };
    core = { editor = "nvim"; };

    delta = {
      navigate = true;
      light = false;
    };

    lfs = { enable = true; };

    merge = {
      tool = "diffview";
      conflictStyle = "zdiff3";
    };
    mergetool = {
      prompt = false;
      keepBackup = false;
      nvimdiff = { layout = "@LOCAL, REMOTE"; };
      # https://gist.github.com/Pagliacii/8fcb4dc64937305c19df9bb3137e4cad
      diffview = { cmd = ''nvim -n -c "DiffviewOpen" "$MERGE"''; };
    };

    diff = {
      tool = "diffview";
      conflictStyle = "zdiff3";
    };
    difftool = {
      prompt = false;
      keepBackup = false;
      nvimdiff = { layout = "@LOCAL, REMOTE"; };
      diffview = { cmd = ''nvim -n -c "DiffviewOpen" "$MERGE"''; };
    };

    alias = {
      diffview = "!nvim -c DiffviewOpen";
      # mergetool = "!nvim -c DiffviewOpen";
      # difftool = "!nvim -c DiffviewOpen";
    };
  };
  home.packages = with pkgs; [ git-credential-manager ];
}
