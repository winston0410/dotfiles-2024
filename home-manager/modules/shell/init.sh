# Add nix generated shell completions to fpath
fpath+=("$HOME/.nix-profile/share/zsh/site-functions")

setopt HIST_REDUCE_BLANKS
# do not share history across terminal as it is annoying
# setopt INC_APPEND_HISTORY
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# For editing command in zsh directly with Neovim. Make sure the widget is available
# https://unix.stackexchange.com/questions/6620/how-to-edit-command-line-in-full-screen-editor-in-zsh
# https://unix.stackexchange.com/a/266636
autoload edit-command-line; 
quick-edit-command-line () {
  # shellcheck disable=SC2034
  local VISUAL="nvim --cmd 'let g:disable_session = v:true' --cmd 'let g:disable_diff_support = v:true' --cmd 'let g:disable_snacks = v:true'"
  edit-command-line
}
zle -N quick-edit-command-line;
# mimic the <C-O> key in Insert mode in Neovim
bindkey '^O' quick-edit-command-line;

# Fix the default Vi behavior of Zsh, that prevents us from using backspace in Insert Mode like in Vim.
# REF https://unix.stackexchange.com/a/290403
bindkey -v '^?' backward-delete-char

# https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#key-bindings
bindkey '^Y' autosuggest-accept

KEYTIMEOUT=1

ZINIT_HOME="${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME"/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice lucid wait
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' use-fzf-default-opts yes
