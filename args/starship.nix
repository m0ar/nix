{ lib
, ...
}:
{
  enable = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  settings = {
    format = lib.concatStrings [
      "$username"
      "$hostname"
      "$container"
      "$directory"
      "$git_branch"
      "$git_commit"
      "$git_status"
      "$cmd_duration"
      "$jobs"
      "\n"
      "$shlvl"
      "$character"
    ];
    directory = {
      read_only = "";
      truncate_to_repo = false;
    };
    git_branch = {
      symbol = "";
    };
    shlvl = {
      disabled = false;
      format = "[$symbol]($style)";
      repeat = true;
      symbol = "❯";
      repeat_offset = 3;
      threshold = 1;
    };
  };
}
