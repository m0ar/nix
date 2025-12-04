# Onedark theme for Helix using shared palette
palette: let
  inherit (palette)
    black red green yellow blue purple cyan white
    gold lightBlack gray faintGray lightGray linenr;
in {
  # Syntax highlighting
  "tag" = { fg = red; };
  "attribute" = { fg = yellow; };
  "comment" = { fg = lightGray; modifiers = [ "italic" ]; };
  "constant" = { fg = cyan; };
  "constant.numeric" = { fg = gold; };
  "constant.builtin" = { fg = gold; };
  "constant.character.escape" = { fg = gold; };
  "constructor" = { fg = blue; };
  "function" = { fg = blue; };
  "function.builtin" = { fg = blue; };
  "function.macro" = { fg = purple; };
  "keyword" = { fg = red; };
  "keyword.control" = { fg = purple; };
  "keyword.control.import" = { fg = red; };
  "keyword.directive" = { fg = purple; };
  "keyword.storage" = { fg = purple; };
  "keyword.operator" = { fg = purple; };
  "label" = { fg = purple; };
  "namespace" = { fg = blue; };
  "operator" = { fg = purple; };
  "special" = { fg = blue; };
  "string" = { fg = green; };
  "type" = { fg = yellow; };
  "variable.builtin" = { fg = blue; };
  "variable.parameter" = { fg = red; };
  "variable.other.member" = { fg = red; };

  # Markup
  "markup.heading" = { fg = red; };
  "markup.raw.inline" = { fg = green; };
  "markup.bold" = { fg = gold; modifiers = [ "bold" ]; };
  "markup.italic" = { fg = purple; modifiers = [ "italic" ]; };
  "markup.strikethrough" = { modifiers = [ "crossed_out" ]; };
  "markup.list" = { fg = red; };
  "markup.quote" = { fg = yellow; };
  "markup.link.url" = { fg = cyan; modifiers = [ "underlined" ]; };
  "markup.link.text" = { fg = purple; };

  # Diff
  "diff.plus" = green;
  "diff.delta" = gold;
  "diff.minus" = red;

  # Diagnostics
  "diagnostic.info" = { underline = { color = blue; style = "curl"; }; };
  "diagnostic.hint" = { underline = { color = green; style = "curl"; }; };
  "diagnostic.warning" = { underline = { color = yellow; style = "curl"; }; };
  "diagnostic.error" = { underline = { color = red; style = "curl"; }; };
  "diagnostic.unnecessary" = { modifiers = [ "dim" ]; };
  "diagnostic.deprecated" = { modifiers = [ "crossed_out" ]; };
  "info" = { fg = blue; modifiers = [ "bold" ]; };
  "hint" = { fg = green; modifiers = [ "bold" ]; };
  "warning" = { fg = yellow; modifiers = [ "bold" ]; };
  "error" = { fg = red; modifiers = [ "bold" ]; };

  # UI
  "ui.background" = { bg = black; };
  "ui.virtual" = { fg = faintGray; };
  "ui.virtual.indent-guide" = { fg = faintGray; };
  "ui.virtual.whitespace" = { fg = lightGray; };
  "ui.virtual.ruler" = { bg = gray; };
  "ui.virtual.inlay-hint" = { fg = lightGray; };
  "ui.virtual.jump-label" = { fg = lightGray; modifiers = [ "bold" ]; };

  "ui.cursor" = { fg = white; modifiers = [ "reversed" ]; };
  "ui.cursor.primary" = { fg = white; modifiers = [ "reversed" ]; };
  "ui.cursor.match" = { fg = blue; modifiers = [ "underlined" ]; };

  "ui.selection" = { bg = faintGray; };
  "ui.selection.primary" = { bg = gray; };
  "ui.cursorline.primary" = { bg = lightBlack; };

  "ui.highlight" = { bg = gray; };
  "ui.highlight.frameline" = { bg = "#97202a"; };

  "ui.linenr" = { fg = linenr; };
  "ui.linenr.selected" = { fg = white; };

  "ui.statusline" = { fg = white; bg = lightBlack; };
  "ui.statusline.inactive" = { fg = lightGray; bg = lightBlack; };
  "ui.statusline.normal" = { fg = lightBlack; bg = blue; modifiers = [ "bold" ]; };
  "ui.statusline.insert" = { fg = lightBlack; bg = green; modifiers = [ "bold" ]; };
  "ui.statusline.select" = { fg = lightBlack; bg = purple; modifiers = [ "bold" ]; };

  "ui.bufferline" = { fg = lightGray; bg = lightBlack; };
  "ui.bufferline.active" = { fg = lightBlack; bg = blue; underline = { color = lightBlack; style = "line"; }; };
  "ui.bufferline.background" = { bg = lightBlack; };

  "ui.text" = { fg = white; };
  "ui.text.directory" = { fg = blue; };
  "ui.text.focus" = { fg = white; bg = lightBlack; modifiers = [ "bold" ]; };

  "ui.help" = { fg = white; bg = gray; };
  "ui.popup" = { bg = gray; };
  "ui.window" = { fg = gray; };
  "ui.menu" = { fg = white; bg = gray; };
  "ui.menu.selected" = { fg = black; bg = blue; };
  "ui.menu.scroll" = { fg = white; bg = lightGray; };

  "ui.debug" = { fg = red; };
}
