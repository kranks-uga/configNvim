local map = vim.keymap.set

-- Общее
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Убрать подсветку поиска" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Сохранить" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Закрыть окно" })
map("i", "jk", "<Esc>", { desc = "Выйти в Normal" })

-- Перемещение между окнами: Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "Окно влево" })
map("n", "<C-j>", "<C-w>j", { desc = "Окно вниз" })
map("n", "<C-k>", "<C-w>k", { desc = "Окно вверх" })
map("n", "<C-l>", "<C-w>l", { desc = "Окно вправо" })

-- Буферы (открытые файлы)
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Следующий буфер" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Закрыть буфер" })

-- Сдвиг выделенных строк вверх/вниз
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Строки вниз" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Строки вверх" })
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Диагностика (ошибки компилятора)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Показать ошибку под курсором" })

-- Выход из терминала
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Терминал -> Normal" })

-- Сборка и запуск текущего файла
map("n", "<leader>r", function() require("config.runner").run() end, { desc = "Собрать и запустить" })
map("n", "<leader>b", function() require("config.runner").build() end, { desc = "Собрать" })

-- Шпаргалка
map("n", "<leader>?", function()
  vim.cmd("vsplit " .. vim.fn.stdpath("config") .. "/CHEATSHEET.md")
  vim.bo.modifiable = false
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
end, { desc = "Шпаргалка" })
