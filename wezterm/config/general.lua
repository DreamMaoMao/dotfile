return {
   -- behaviours
   automatically_reload_config = true,
   check_for_updates = false,
   exit_behavior = 'CloseOnCleanExit', -- if the shell program exited with a successful status
   status_update_interval = 1000,

   -- scrollbar
   scrollback_lines = 5000,

   -- paste behaviours
   canonicalize_pasted_newlines = 'CarriageReturn',

   hyperlink_rules = {
      -- Matches: a URL in parens: (URL)
      {
         regex = '\\((\\w+://\\S+)\\)',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in brackets: [URL]
      {
         regex = '\\[(\\w+://\\S+)\\]',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in curly braces: {URL}
      {
         regex = '\\{(\\w+://\\S+)\\}',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in angle brackets: <URL>
      {
         regex = '<(\\w+://\\S+)>',
         format = '$1',
         highlight = 1,
      },
      -- Then handle URLs not wrapped in brackets
      {
         regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
         format = '$0',
      },
      -- implicit mailto link
      {
         regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
         format = 'mailto:$0',
      },
   },

   quick_select_patterns = {
      -- match things that look like sha1 hashes
      -- (this is actually one of the default patterns)
      '[0-9a-f]{7,40}',
      "core-[0-9A-Za-z]+-[0-9A-Za-z]+-[0-9A-Za-z]+",
      "ghp_[0-9a-zA-Z]{36}",
      "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}",
    }
}
