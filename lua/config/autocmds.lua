local au = vim.api.nvim_create_autocmd

-- Подсветить скопированный текст
au("TextYankPost", { callback = function() vim.hl.on_yank({ timeout = 200 }) end })

-- C/C++: отступ 4 (как и везде); Rust: rustfmt сам форматирует
-- ASM: отступ 8 пробелов — так же, как форматирует nasmfmt
au("FileType", {
  pattern = { "asm", "nasm" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.commentstring = "; %s"
  end,
})

-- Вернуть курсор на место последнего редактирования
au("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
