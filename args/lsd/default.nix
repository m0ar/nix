{ ... }:
{
  enable = true;
  settings = {
    date = "relative";
    ignore-globs = [
      ".git"
      "node_modules"
    ];
    blocks = [
      "permission"
      "user"
      "group"
      "size"
      "date"
      #"git"
      "name"
    ];
  };
}
