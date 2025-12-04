{ pkgs, cpk, ... }:
let
  # Define completions to generate at build time
  zshCompletionSpecs = [
    { name = "kubectl"; pkg = pkgs.kubectl; cmd = "kubectl completion zsh"; }
    { name = "docker"; pkg = pkgs.docker-client; cmd = "docker completion zsh"; }
    { name = "fnm"; pkg = pkgs.fnm; cmd = "fnm completions --shell zsh"; }
    { name = "kubo"; pkg = pkgs.kubo; cmd = "ipfs commands completion zsh"; }
    { name = "eksctl"; pkg = pkgs.eksctl; cmd = "eksctl completion zsh"; }
    { name = "pnpm"; pkg = pkgs.pnpm_10; cmd = "pnpm completion zsh"; }
    { name = "gh"; pkg = pkgs.gh; cmd = "gh completion -s zsh"; }
    { name = "cpk"; pkg = cpk; cmd = "cpk completion zsh"; }
  ];

  # Generate a completion script at build time
  mkZshCompletion = { name, pkg, cmd }:
    pkgs.runCommand "${name}-zsh-completion" { nativeBuildInputs = [ pkg ]; } ''
      ${cmd} > $out
    '';

  # Generate source lines for all completions
  completionSources = builtins.concatStringsSep "\n"
    (map (spec: "source ${mkZshCompletion spec}") zshCompletionSpecs);

in
{
  enable = true;
  autosuggestion.enable = true;
  enableVteIntegration = true;
  autocd = true;
  syntaxHighlighting.enable = true;
  history = {
    extended = true;
    append = true;
    ignoreDups = true;
    expireDuplicatesFirst = true;
    ignoreSpace = true;
    size = 1000000;
    save = 1000000;
    share = false;
  };
  shellAliases = {
    # If alias replacement ends with a space, alias expansion is enabled on the following word
    sudo = "sudo --preserve-env=PATH,TERMINFO env ";
    cp = "cp -i";
    # ls = "ls --color=auto";
    nix = "noglob nix"; # nomatch handler doesn't like flake URIs
    curl = "noglob curl "; # nomatch handler doesn't like query params
    ip = "ip --color=auto";
    nvm = "fnm ";
    kubectl = "kubecolor";
    zshprofile = "time ZSH_DEBUGRC=1 zsh -i -c exit";
    #Search repos with 'paru' and 'fzf'
    parus = "paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S";
    #Search locally installed packages with 'paru', 'fzf' and 'bat'
    parup = "paru -Qq | fzf --preview 'paru -Qil {}' --layout=reverse --bind 'enter:execute(paru -Qil {} | bat)'";
    add_hp_printer = "NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'";
  };
  completionInit = ''
    # AWS/vault autocomplete relies on bash completion
    autoload bashcompinit
    bashcompinit

    autoload -Uz compinit
    compinit

    # Pre-generated completions (built at nix build time, no subprocess spawning)
    ${completionSources}

    # kubecolor uses kubectl completions
    compdef kubecolor=kubectl

    # Bash-style completions (these use complete -C, not zsh scripts)
    complete -C "${pkgs.awscli2}/bin/aws_completer" aws
    complete -C "${pkgs.vault-bin}/bin/vault" vault
  '';
  envExtra = builtins.readFile ./env.zsh;
  profileExtra = builtins.readFile ./profile.zsh;
  initExtraFirst = ''
    if [ -n "$ZSH_DEBUGRC" ]; then
      zmodload zsh/zprof
    fi
  '';
  initExtra = builtins.readFile ./init.zsh + ''
    if [ -n "$ZSH_DEBUGRC" ]; then
      zprof
    fi
  '';
}
