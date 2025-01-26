-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here


-- 自动切换工作目录
function ChangeDirToFileOrParent()
  local path = vim.fn.expand('%:p')
  if vim.fn.isdirectory(path) == 1 then
    -- 如果路径是目录，则更改工作目录到该目录
    vim.cmd('cd ' .. path)
    -- 加载目录上次打开的session
    -- require('persistence').load()
  else
    local parent_dir = vim.fn.fnamemodify(path, ':h')
    if vim.fn.isdirectory(parent_dir) == 1 then
      vim.cmd('cd ' .. parent_dir)
    end
  end
end

-- 在打开文件或目录后自动调用函数
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = ChangeDirToFileOrParent
})
