# Add nix generated shell completions to fpath
fpath+=("$HOME/.nix-profile/share/zsh/site-functions")

setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# Fix the default Vi behavior of Zsh, that prevents us from using backspace in Insert Mode like in Vim.
# REF https://unix.stackexchange.com/a/290403
bindkey -v '^?' backward-delete-char

KEYTIMEOUT=1

ZINIT_HOME="${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME"/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice lucid wait
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# This will break completions for other ssh related utilities
# sunlei/zsh-ssh \

zinit lucid wait for \
    zsh-users/zsh-completions \
    OMZP::bun \
    OMZP::docker \
    OMZP::docker-compose \
    OMZP::dotnet \
    OMZP::git

bw completion --shell zsh >"$ZINIT[COMPLETIONS_DIR]/_bw"

# no idea why chafa completion does not work
zinit as"completion" lucid wait for \
    https://github.com/hpjansson/chafa/blob/master/tools/completions/zsh-completion.zsh

# To complete completions installation, run zicompinit
zinit for \
    lucid wait"1" atload"zicompinit; zicdreplay" OMZP::rbw
