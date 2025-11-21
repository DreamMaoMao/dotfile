local prose = require 'nvim-prose'

require 'lualine'.setup {
    sections = {
        lualine_x = {
                { prose.word_count,   cond = prose.is_available },
                { prose.reading_time, cond = prose.is_available },
            },
    },
}