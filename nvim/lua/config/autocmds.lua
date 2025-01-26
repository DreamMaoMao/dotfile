-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- 创建一个自动命令组
vim.cmd("augroup openbuffer")
-- 清除该组中的所有自动命令
vim.cmd("autocmd!")
-- 在该组中添加多个自动命令，如当创建一个新的缓冲区时执行一个cmdline命令
vim.cmd("autocmd BufNew * nnoremap <buffer> <S-k> 5k")
vim.cmd("autocmd BufNew * nnoremap <buffer> <S-j> 5j")
vim.cmd("autocmd BufNew * inoremap <buffer> <C-h> <Left>")
vim.cmd("autocmd BufNew * inoremap <buffer> <C-l> <Right>")
-- 结束该组的定义
vim.cmd("augroup END")
