{ pubkey, ...}:
# Injected from home.nix
{ allowedSignersFile }:
{
  enable = true;
  userName = "m0ar";
  userEmail = "edvard@hubinette.me";
  aliases = {
    a = "add";
    c = "commit";
    d = "diff";
    co = "checkout";
    f = "fetch";
    fap = "fetch --all --prune";
    lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
    lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    st = "status";
    graf = ''
      !git log \
            --color \
            --graph \
            --pretty=format:"'%Cblue%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr)%C(bold blue) <%an> %Creset'" \
            --abbrev-commit \
            --all \
            | sed 's|tag:||g'\
            | sed 's|HEAD| head|g'\
            | sed 's|origin/|  |g'\
            | less -R
    '';
    root = "rev-parse --show-toplevel";
  };
  delta = {
    enable = true;
    options = {
      dark = true;
      navigate = true;
      line-numbers = true;
      hyperlinks = true;
    };
  };
  extraConfig = {
    url = {
      "git@github.com:" = {
        insteadOf = [
          "https://github.com/"
          "git+https://github.com/"
        ];
      };
    };
    diff = {
      colorMoved = "default";
    };
    merge = {
      conflictStyle = "zdiff3";
    };
    status = {
      showUntrackedFiles = "all";
    };
    commit = { gpgSign = true; };
    tag = { gpgSign = true; };
    init = {
      defaultBranch = "main";
    };
    gpg = {
      format = "ssh";
      ssh = { allowedSignersFile = "~/" + allowedSignersFile; };
    };
    user = { signingKey = pubkey; };
  };
}
