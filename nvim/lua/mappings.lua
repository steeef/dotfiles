local api, g = vim.api, vim.g

local function map(mode, shortcut, command, options)
  options = vim.tbl_extend('keep', options or {}, {noremap = true, silent = true, expr = false})
  api.nvim_set_keymap(mode, shortcut, command, options)
end

local function nmap(shortcut, command, options)
  map('n', shortcut, command, options)
end

local function imap(shortcut, command, options)
  map('i', shortcut, command, options)
end

local function vmap(shortcut, command, options)
  map('v', shortcut, command, options)
end

local function cmap(shortcut, command, options)
  map('c', shortcut, command, options)
end

local function tmap(shortcut, command, options)
  map('t', shortcut, command, options)
end

local function omap(shortcut, command, options)
  map('o', shortcut, command, options)
end

-- mapping

--- set leader to space
map('', '<Space>', '<Nop>')
g.mapleader = " "
g.maplocalleader = " "

--- swap colon with semicolon
nmap(';', ':', {noremap = true, silent = false, expr = false})
nmap(':', ';', {noremap = true, silent = false, expr = false})
vmap(';', ':', {noremap = true, silent = false, expr = false})
vmap(':', ';', {noremap = true, silent = false, expr = false})

-- more natural movement with wrap on
nmap('j', 'gj')
nmap('k', 'gk')
vmap('j', 'gj')
vmap('k', 'gk')

-- Split line (sister to [J]oin lines)
-- The normal use of S is covered by cc, so don't worry about shadowing it.
nmap('S', 'i<cr><esc><right>')

nmap('Q', '@q') -- simplify macro playback

-- Use Enter to exit normal,visual,command mode
nmap('<CR>', '<Esc>')
vmap('<CR>', '<Esc>gV')
omap('<CR>', '<Esc>')
-- Use CTRL-O to create new line in insert mode
imap('<C-o>', '<CR>')

-- Reselect visual block after indent/outdent
vmap('<', '<gv')
vmap('>', '>gv')


nmap('<leader>W', ":%s/\\s\\+$//<cr>:let @/=''<CR>") -- Remove trailing whitespace from entire buffer


nmap('<CR>', 'o<ESC>') -- insert blank line below


nmap('<leader>w', '<Cmd>botright vnew<CR>') -- new vertical window

-- window navigation with tmux-navigator
nmap('<C-l>', ':TmuxNavigateRight <CR>')
nmap('<C-j>', ':TmuxNavigateDown <CR>')
nmap('<C-k>', ':TmuxNavigateUp <CR>')
nmap('<C-h>', ':TmuxNavigateLeft <CR>')

-- Telescope
nmap('<leader> ', ':Telescope find_files<CR>')
nmap('<leader>b', ':Telescope buffers<CR>')
nmap('<leader>a', ':Telescope live_grep<CR>')

-- vimagit
nmap('<leader>g', ':Magit<Enter>')

-- vim-commentary
nmap('gc', '<Plug>Commentary')
nmap('gcc', '<Plug>CommentaryLine')

-- vim-easy-align
vmap('<Enter>', ':EasyAlign<Enter>')
