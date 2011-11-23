#Gitと連携する部分
# gitのブランチ名と変更状況をプロンプトに表示する 
autoload -Uz is-at-least
if is-at-least 4.3.10; then
  # バージョン管理システムとの連携を有効にする 
  autoload -Uz vcs_info
  autoload -Uz add-zsh-hook

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '@%b%u%c'
  zstyle ':vcs_info:git:*' actionformats '@%b|%a%u%c'

  # VCSの更新時にPROMPTを自動更新する
  function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    psvar[2]=$(_git_not_pushed)
  }
  function _git_not_pushed() {
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
      head="$(git rev-parse HEAD)"
      for x in $(git rev-parse --remotes)
      do
        if [ "$head" = "$x" ]; then
          return 0
        fi
      done
      echo "?"
    fi
    return 0
  }
  add-zsh-hook precmd _update_vcs_info_msg
fi
#RPROMPT（右側のほう）に表示させる部分
RPROMPT="%{${fg[green]}%}%1v%2v [%~]%{${reset_color}%}"

# 標準の補完設定
autoload -U compinit
compinit

# ディレクトリ名を入力するだけでカレントディレクトリを変更
setopt auto_cd

# タブキー連打で補完候補を順に表示
setopt auto_menu

# 自動修正機能(候補を表示)
setopt correct

# Ctrl-h で単語ごとに削除
bindkey "^h" backward-kill-word

# 補完される前にオリジナルのコマンドまで展開してチェックする
setopt complete_aliases

# エイリアス
alias ls='ls --color=auto'
alias h='history -E -32'
alias ll='ls -laF --color | more'