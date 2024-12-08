{ ... }:
{
  enable = true;
  mpdMusicDir = "~/Music";
  settings = {
    mpd_host = "127.0.0.1";
    mpd_port = "6600";
    
    # visualizer_data_source  = "/tmp/mpd.fifo";
    # visualizer_output_name  = "fifo output";
    # visualizer_in_stereo  = "yes";
    # visualizer_type  = "spectrum";
    # visualizer_color  = "blue, cyan, green, yellow, magenta, red";
    # visualizer_look  = "xs";
    # visualizer_fps  = "60";
    # visualizer_autoscale  = "yes";
    # visualizer_spectrum_smooth_look  = "yes";

    playlist_disable_highlight_delay  = "-1";
    allow_for_physical_item_deletion  = "no";
    message_delay_time  = "8";
    song_list_format  = "$(red){%a}$(end) $(blue){%t}$(end) $R $(green){%b}$(end) $(magenta)({%l})$(end)";
    song_status_format  = "{$2%a$2} {$3%b$3} {$5%t$5}";
    song_library_format  = "%t";
    song_window_title_format  = "{%a-%t}";
    song_columns_list_format  = "(28)[red]{a} (36)[green]{t} (29)[blue]{b} $R(8)[magenta]{l}";
    playlist_display_mode  = "columns";
    browser_display_mode  = "columns";
    titles_visibility  = "yes";
    incremental_seeking  = "yes";
    autocenter_mode  = "yes";
    header_visibility  = "yes";
    statusbar_visibility  = "yes";
    cyclic_scrolling  = "yes";
    display_bitrate  = "yes";
    ignore_leading_the  = "no";
    enable_window_title  = "yes";
    # progressbar_look  = "▬▬▬";
    progressbar_look = "─╼ ";
    user_interface  = "alternative";
    alternative_header_first_line_format  = "{$b$2%a$9} {$5%t$9}";
    alternative_header_second_line_format = "{$3%b$9} {$4(%y)$9}";
    alternative_ui_separator_color  = "blue";
    playlist_separate_albums  = "no";
    colors_enabled  = "yes";
    empty_tag_color  = "blue";
    header_window_color  = "white";
    display_volume_level  = "yes";
    state_line_color  = "cyan";
    state_flags_color  = "magenta";
    main_window_color  = "green";
    color1  = "white";
    color2  = "blue";
    progressbar_color  = "black";
    statusbar_color  = "cyan";
    window_border_color  = "red";
    active_window_border  = "red";
    follow_now_playing_lyrics  = "yes";
    clock_display_seconds  = "yes";
    current_item_prefix  = "$(green_235)$b";
    current_item_suffix  = "$/b$(end)";
    current_item_inactive_column_prefix  = "$(green_236)";
    current_item_inactive_column_suffix  = "$(end)";
    now_playing_prefix  = "$b";
    now_playing_suffix  = "$/b";
    selected_item_prefix  = "$(white)$b";
    selected_item_suffix  = "$/b$(end)";
    browser_playlist_prefix  = "$2Playlist$9 ";
    modified_item_prefix  = ">> ";
  };
}