local has_rainbow = pcall(require, 'rainbow')

require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {enable = true},
  rainbow = {
    enable = has_rainbow,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = 500, -- Do not enable for files with more than n lines, int
    colors = {
      '#44bec7',
      '#b5bd68',
      '#f0c674',
      '#81a2be',
      '#b294bb',
      '#8abeb7',
      '#c5c8c6',
    }
  }
}
