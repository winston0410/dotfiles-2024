{ inputs, unstable, lib, config, pkgs, ... }: {
  home.packages = with pkgs;
    [
      rust-analyzer
      gopls
      rnix-lsp
      ccls
      haskell-language-server
      elixir_ls
      nodePackages.purescript-language-server
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.yaml-language-server
      nodePackages.vls
      nodePackages.vim-language-server
      nodePackages.typescript-language-server
      nodePackages.pyright
      haskellPackages.dhall-lsp-server
      terraform-ls
      solargraph
      metals
      nodePackages.vscode-langservers-extracted
      lua-language-server
      deno
    ] ++ [ unstable.nodePackages.svelte-language-server ];
}
