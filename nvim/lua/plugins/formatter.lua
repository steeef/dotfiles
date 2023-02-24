return {
  'mhartington/formatter.nvim', -- automatically format specific filetypes
  config = function()
    local reorder_python_imports = function()
      return {
        exe = "reorder-python-imports",
        args = { "-" },
        stdin = true,
      }
    end

    local black = function()
      return {
        exe = "black",
        args = { "-q", "-" },
        stdin = true,
      }
    end

    local tffmt = function()
      return {
        exe = "terraform",
        args = { "fmt", "-" },
        stdin = true,
      }
    end

    require('formatter').setup({
      filetype = {
        python = {black, reorder_python_imports},
        terraform = {tffmt},
      }
    })

    vim.cmd([[
      augroup MyFormatAutoCmd
      autocmd!
      autocmd BufWritePost *.py,*.tf FormatWrite
      augroup END
    ]])
  end
}
