{ inputs, unstable, lib, config, pkgs, ... }: {
  imports = [ ./lsp.nix ./formatter.nix ];

  home.packages = with pkgs; [
    figlet
    fastfetch
    (unstable.neovim.override {
      extraLuaPackages =
        (ps: with ps; [ luafilesystem jsregexp luarocks magick luassert ]);
    })
    # FIXME No idea why but override from lua package does not work and the version will be 5.2, we have to use lua5_1 instead
    # (lua.override { version = "5.1.0"; })
    lua5_1
    luarocks
    # needed for treesitter
    tree-sitter
    gcc14
    nodejs_20
    # needed for fzf-lua
    fzf
    fd
    bat
    delta
    chafa
    # needed for snacks.nvim
    imagemagick
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.zsh.initExtra = ''
    nrg() {
        if [[ -p /dev/stdin ]] || [ ! -t 0 ]; then
            nvim -c "BaleiaColorize" -c "lua Snacks.picker.lines()" -
        else
            nvim -c "lua Snacks.picker.grep()"
        fi
    }
  '';

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
    oil = ''nvim -c "Oil"'';
    neogit = "nvim -c 'lua require(\"neogit\").open()'";
    k8s = "nvim -c 'lua require(\"kubectl\").toggle({ tab = false })'";
    nfd = ''nvim -c "lua Snacks.picker.files()"'';
  };

  xdg.configFile = {
    "nvim/init.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink ./init.lua;
    };
    "nvim/.luarc.jsonc" = {
      source = config.lib.file.mkOutOfStoreSymlink ./.luarc.jsonc;
    };
    "nvim/ftplugin" = {
      source = config.lib.file.mkOutOfStoreSymlink ./ftplugin;
    };
  };
}
