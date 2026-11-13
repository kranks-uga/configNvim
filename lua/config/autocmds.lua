local au = vim.api.nvim_create_autocmd

au("TextYankPost", {
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

au("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
