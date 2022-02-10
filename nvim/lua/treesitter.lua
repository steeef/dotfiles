require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {enable = true},
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than n lines, int
    colors = { -- Dracula theme
      '#ff5555',
      '#ffb86c',
      '#f1fa8c',
      '#50fa7b',
      '#8be9fd',
      '#bd93f9',
      '#ff79c6',
    }
  }
}
