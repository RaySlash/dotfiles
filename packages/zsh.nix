{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.zsh ];

  config."zshrc".content = ''
    HISTFILE="$HOME/.zsh-history"
    HISTSIZE="1000"
    SAVEHIST="1000"
    setopt autocd extendedglob append_history extended_history hist_expire_dups_first hist_find_no_dups hist_ignore_all_dups hist_ignore_dups hist_ignore_space hist_reduce_blanks hist_save_no_dups hist_verify inc_append_history share_history  auto_cd auto_list auto_pushd bang_hist interactive_comments multios no_beep prompt_subst pushd_ignore_dups pushd_minus
    bindkey -e

    zstyle :compinstall filename '$HOME/.zshrc'
    zstyle ':completion:*' use-cache true
    zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/.zsh/.zcompcache"
    zstyle ':completion:*' completer _complete _match _approximate
    zstyle ':completion:*:match:*' original only
    zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
    zstyle ':completion:*:matches' group 'yes'
    zstyle ':completion:*:options' description 'yes'
    zstyle ':completion:*:options' auto-description '%d'
    zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
    zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
    zstyle ':completion:*:messages' format ' %F{lightpurple} -- %d --%f'
    zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
    zstyle ':completion:*:default' list-prompt '%S%M matches%s'
    zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
    zstyle ':completion:*' group-name '\'
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
    zstyle ':completion:*' rehash true
    zstyle ':completion:*' menu select
    zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}
  zstyle ':completion:*:parameters'  list-colors '=*=31'
    zstyle ':completion:*:commands' list-colors '=*=1;32'
    zstyle ':completion:*:aliases' list-colors '=*=32'
    zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
    zstyle ':completion:*:options' list-colors '=(#b)(-[^ -]#)#( [^--]*)=32=32=37'
    zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'

    autoload -Uz compinit
    fpath=($HOME/.zsh/zsh-completions/src $fpath) #zsh-completions
    compinit

    eval "$(${pkgs.starship}/bin/starship init zsh)"
    eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
    eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
    eval "$(${pkgs.fzf}/bin/fzf --zsh)"

    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

    export EDITOR=emacs
  '';

  config.zshAliases = let
    eza_params = "--icons --git --classify --group-directories-first";
  in {
    ls = "${pkgs.eza}/bin/eza ${eza_params}";
    ll = "${pkgs.eza}/bin/eza --all --header --long ${eza_params}";
    llm = "${pkgs.eza}/bin/eza --all --header --long --sort=modified ${eza_params}";
    tree = "${pkgs.eza}/bin/eza --tree";
    ffd = "cd $(${pkgs.fd}/bin/fd -t d --max-depth 4 . $HOME/Projects | ${pkgs.fzf}/bin/fzf)";
  };
}
