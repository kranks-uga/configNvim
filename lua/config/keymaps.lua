local map = vim.keymap.set

-- Базовое
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Сохранить" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Сохранить" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Закрыть окно" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Убрать подсветку поиска" })

-- Быстрый выход из insert (оставил как опцию, можно не использовать)
map("i", "jk", "<Esc>", { desc = "Выйти в Normal" })

-- Перемещение между окнами
map("n", "<C-h>", "<C-w>h", { desc = "Окно влево" })
map("n", "<C-j>", "<C-w>j", { desc = "Окно вниз" })
map("n", "<C-k>", "<C-w>k", { desc = "Окно вверх" })
map("n", "<C-l>", "<C-w>l", { desc = "Окно вправо" })

-- Буферы
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Следующий файл" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Предыдущий файл" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Закрыть файл" })

-- Удобное выделение
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Диагностика
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Показать ошибку" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Предыдущая ошибка" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Следующая ошибка" })

-- Терминал
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Выйти из терминала" })
