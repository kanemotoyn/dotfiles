HISTFILE=~/.zsh_history # 履歴ファイル保存先
HISTSIZE=10000 # メモリに保存される履歴の件数
SAVEHIST=100000 # 履歴ファイルに保存される履歴の件数
setopt share_history # 異なるウィンドウでhistoryを共有
setopt hist_ignore_dups # 直前と同じコマンドは履歴に追記しない
#setopt hist_ignore_all_dups # 重複するコマンドは古い方を削除する
setopt hist_reduce_blanks # 余分な空白は詰めて記録する
setopt hist_verify # `!!`を実行したときにいきなり実行せずコマンドを見せる
setopt hist_no_store # historyコマンドは履歴に登録しない。
function history-all { history -E 1 } # 前履歴一覧を表示

autoload -Uz compinit && compinit -u # 補完機能の強化
setopt correct # 入力しているコマンド名が間違っている場合もしかして：を出す
setopt nobeep # ビープ音を鳴らさない
setopt no_tify # バックグラウンドジョブが終了したらすぐに知らせる。
#unsetopt auto_menu # タブによるファイルの順番切り替えをしない
setopt auto_pushd # cd -[tab]で過去のディレクトリに飛べるようにする
setopt pushd_ignore_dups # auto_pushdで重複するディレクトリは記録しない

disable r # build-in r commandを無効化(直前コマンドを再実行機能を無効化)
setopt ignoreeof # ctrl + Dでログアウトしない。
fpath=(~/.zsh $fpath) # denoの補完を有効にするために追加 https://deno.land/manual/getting_started/setup_your_environment

: "Ctrl-Yで上のディレクトリに移動できる" && {
    function cd-up { zle push-line && LBUFFER='builtin cd ..' && zle accept-line }
    zle -N cd-up
    bindkey "^Y" cd-up
}
: "Ctrl-Wでパスの文字列などをスラッシュ単位でdeleteできる" && {
    autoload -U select-word-style
    select-word-style bash
}
: "Ctrl-[で直前コマンドの単語を挿入できる" && {
    autoload -Uz smart-insert-last-word
    zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*' # [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
    zle -N insert-last-word smart-insert-last-word
    bindkey '^[' insert-last-word
    # see http://qiita.com/mollifier/items/1a9126b2200bcbaf515f
}
: "sshコマンド補完を~/.ssh/configから行う" && {
    function _ssh { compadd `fgrep 'Host ' ~/.ssh/config_* | grep -v '*' |  awk '{print $2}' | sort` }
    compdef mosh=ssh
}
: "Emacsデーモンを使用して、Emacsを立ち上げる" && {
    function emacsdaemon() {
        if [[ 0 -eq `ps ax | grep Emacs | grep daemon | wc -l` ]] emacs --daemon
           #emacsclient -t $*  # CUIのオプションは {-t} or {-nw}どちらでもOK
           emacsclient -c $* # GUI
    }
}

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大文字、小文字を区別せず補完する
zstyle ':completion:*' insert-tab false # 何も入力されていないときにTabを挿入しない

## Application Shortcuts
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"

## Preparing zsh for extension
## Create a ".zsh" folder in advance.
## $ mkdir ~/.zsh
if [[ -d ~/.zsh/zsh-completions/src ]]; then
    # https://github.com/zsh-users/zsh-completions
    fpath=(~/.zsh/zsh-completions/src $fpath)
fi

if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # url: https://github.com/zsh-users/zsh-autosuggestions
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    # url: https://github.com/zsh-users/zsh-syntax-highlighting
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # custom color setting refs
    #   [1] https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/highlighters/main/main-highlighter.zsh
    #   [2] https://qiita.com/KazIgu/items/6aa66560c4137ede25a1
    ZSH_HIGHLIGHT_STYLES[comment]=fg=white
fi

if [[ -f ~/.zsh/zsh-abbrev-alias/abbrev-alias.plugin.zsh ]]; then
    # 略語展開(iab)設定
    # https://github.com/momo-lab/zsh-abbrev-alias
    # https://github.com/momo-lab/zsh-abbrev-alias/blob/master/README.md
    source ~/.zsh/zsh-abbrev-alias/abbrev-alias.plugin.zsh
    abbrev-alias ec="emacs --batch -f batch-byte-compile ~/.emacs.d/init.el"
    abbrev-alias ekill="emacsclient -e '(kill-emacs)'"
    abbrev-alias e="emacsclient -c $*"
    abbrev-alias enw="emacsclient -t $*"
    abbrev-alias gpl="git pull"
    abbrev-alias gps="git push"
    abbrev-alias gco="git commit -av"
    abbrev-alias ga="git add -A"
    abbrev-alias gs="git status -s"
    abbrev-alias tree="exa -T"
    abbrev-alias gist="gh gist"
    abbrev-alias -g G="| grep"
    abbrev-alias -g and="|"
fi

if [[ -f ~/.fzf.zsh ]]; then
    # fzf install and zsh keybind setup
    # $ brew install fzf
    # $ $(brew --prefix)/opt/fzf/install
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
