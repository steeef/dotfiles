local api, g = vim.api, vim.g

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- mapping

--- set leader to space
map('', '<Space>', '<Nop>', {silent = true})
g.mapleader = " "
g.maplocalleader = " "

--- swap colon with semicolon
map('n', ';', ':')
map('n', ':', ';')
map('v', ';', ':')
map('v', ':', ';')

--- new vertical window
map('n', '<leader>w', '<Cmd>botright vnew<CR>', {silent = true})

--- window navigation with tmux-navigator
map('n', '<C-l>', ':TmuxNavigateRight <CR>', {silent = true})
map('n', '<C-j>', ':TmuxNavigateDown <CR>', {silent = true})
map('n', '<C-k>', ':TmuxNavigateUp <CR>', {silent = true})
map('n', '<C-h>', ':TmuxNavigateLeft <CR>', {silent = true})

-- Telescope
map('n', '<leader> ', ':Telescope find_files<CR>', {silent = true})
map('n', '<leader>b', ':Telescope buffers<CR>', {silent = true})
map('n', '<leader>a', ':Telescope live_grep<CR>', {silent = true})
