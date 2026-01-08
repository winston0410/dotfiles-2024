{ inputs, lib, config, pkgs, ... }: let 
    
in {
  programs.git.enable = true;
  programs.git.lfs.enable = true;

  home.shellAliases = {
    g = "git";
  };
  programs.git.settings = {
    # blame = {
    #     ignoreRevsFile = ":(optional).git-blame-ignore-revs";
    # };
    pack = {
      threads = 0;
      sparse = true;
    };
    pull = { ff = true; };
    # REF https://stackoverflow.com/a/61920529
    http = { postBuffer = 2097152000; sslBackend = "openssl"; };

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

    rebase = {
      autosquash = true;
    };
    merge = {
      tool = "diffview";
      conflictStyle = "zdiff3";
    };
    mergetool = {
      prompt = false;
      keepBackup = false;
      # diffview.nvim is still needed for merging, as nvimdiff and its variants do not support resolve conflicts with keybindings
      # https://gist.github.com/Pagliacii/8fcb4dc64937305c19df9bb3137e4cad
      diffview = { cmd = ''nvim --cmd 'let g:disable_session = v:true' -n -c "DiffviewOpen" "$MERGE"''; };
    };

    diff = { 
      conflictStyle = "zdiff3";
      tool = "nvim_difftool";

      sqlite3 = {
        textconv = "sh -c 'sqlite3 $0 .dump'";
      };
    };
    difftool = {
      prompt = false;
      keepBackup = false;
      # NOTE nvim_difftool supports both file diff and dir diff, therefore it can replace nvimdiff completely, and no point to use latter anymore
      # We cannot enforce dir diff here, therefore we will need git difftool -d
      nvim_difftool = { cmd = ''nvim --cmd 'let g:disable_session = v:true' -c "packadd nvim.difftool" -c "DiffTool $LOCAL $REMOTE"''; };
    };
  };
  home.packages = with pkgs; [ git-credential-manager ];
}
