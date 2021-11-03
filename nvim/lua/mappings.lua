local api, g = vim.api, vim.g

local function map(mode, shortcut, command)
  local options = {noremap = true, silent = true}
  api.nvim_set_keymap(mode, shortcut, command, options)
end

local function nmap(shortcut, command)
  map('n', shortcut, command)
end

local function imap(shortcut, command)
  map('i', shortcut, command)
end

local function vmap(shortcut, command)
  map('v', shortcut, command)
end

local function cmap(shortcut, command)
  map('c', shortcut, command)
end

local function tmap(shortcut, command)
  map('t', shortcut, command)
end

local function omap(shortcut, command)
  map('o', shortcut, command)
end

-- mapping

--- set leader to space
map('', '<Space>', '<Nop>')
g.mapleader = " "
g.maplocalleader = " "

--- swap colon with semicolon
nmap(';', ':')
nmap(':', ';')
vmap(';', ':')
vmap(':', ';')

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
