return {
  'cappyzawa/trim.nvim', -- trim trailing whitespace
  config = function()
    if pcall(require, 'trim') then
      require('trim').setup({
        ft_blocklist = {'markdown'},

        patterns = {
          [[%s/\s\+$//e]],           -- remove unwanted spaces
          [[%s/\($\n\s*\)\+\%$//]],  -- trim last line
        },
      })
    end
  end
}
