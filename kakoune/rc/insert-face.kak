# Switch cursor color in insert mode
set-face global InsertCursor default,red+B

hook global ModeChange .*:.*:insert %{
    set-face window PrimaryCursor InsertCursor
    set-face window PrimaryCursorEol InsertCursor
}

hook global ModeChange .*:insert:.* %{
  try %{
    unset-face window PrimaryCursor
    unset-face window PrimaryCursorEol
  }
}
