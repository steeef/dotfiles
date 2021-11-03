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

--- new vertical window
nmap('<leader>w', '<Cmd>botright vnew<CR>')

--- window navigation with tmux-navigator
nmap('<C-l>', ':TmuxNavigateRight <CR>')
nmap('<C-j>', ':TmuxNavigateDown <CR>')
nmap('<C-k>', ':TmuxNavigateUp <CR>')
nmap('<C-h>', ':TmuxNavigateLeft <CR>')

-- Telescope
nmap('<leader> ', ':Telescope find_files<CR>')
nmap('<leader>b', ':Telescope buffers<CR>')
nmap('<leader>a', ':Telescope live_grep<CR>')
