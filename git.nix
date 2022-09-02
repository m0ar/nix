{
  enable = true;
  userName = "m0ar";
  userEmail = "edvard@hubinette.me";
  aliases = {
    a = "add";
    c = "commit";
    co = "checkout";
    f = "fetch";
    lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
    lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    st = "status";
    graf = ''!git log \
      --color \
      --graph \
      --pretty=format:'%Cblue%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr)%C(bold blue) <%an> %Creset'" \
      --abbrev-commit \
      --all \
      | sed 's|refs/tf_ok/| |g'\
      | sed 's|tag:||g'\
      | sed 's|HEAD| head|g'\
      | sed 's|origin/|  |g'\
      | less -R
    '';
    root = "rev-parse --show-toplevel";
  };
  delta.enable = true;
}
