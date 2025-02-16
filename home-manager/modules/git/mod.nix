{ inputs, lib, config, pkgs, isDarwin, ... }: {
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
      "https://forgejo.28281428.xyz" = { provider = "generic"; };
      credentialStore = "cache";
      helper = if isDarwin then
        [ "${pkgs.git-credential-manager}/bin/git-credential-manager" ]
      else
        [ "${pkgs.git-credential-manager}/bin/git-credential-manager" ];
    };
    core = { editor = "nvim"; };

    delta = {
      navigate = true;
      light = false;
    };

    lfs = { enable = true; };

    merge = { tool = "nvimdiff"; };

    diff = { tool = "nvimdiff"; };
  };
  home.packages = with pkgs;
    [
      # NOTE it is trigger every single time when I open a Git repo, cannot fix it at all
      # git-credential-oauth
      git-credential-manager
    ];
}
