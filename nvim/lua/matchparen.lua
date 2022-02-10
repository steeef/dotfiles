require('matchparen').setup({
    on_startup = true, -- Should it be enabled by default
    timeout = 150, -- timeout in ms to drop searching for matched character in normal mode
    timeout_insert = 50, -- same but in insert mode
})
