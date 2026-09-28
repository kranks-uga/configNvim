-- Сборка/запуск текущего файла в терминале снизу.
-- Бинарник кладётся рядом с исходником (тот же путь без расширения),
-- с отладочной информацией (-g), чтобы его сразу можно было открыть в отладчике.
local M = {}

local function find_up(name)
  return vim.fs.root(0, name)
end

local function commands()
  local file = vim.fn.expand("%:p")
  local out = vim.fn.expand("%:p:r")
  local ft = vim.bo.filetype
  local f, o = vim.fn.shellescape(file), vim.fn.shellescape(out)

  if ft == "rust" then
    local root = find_up("Cargo.toml")
    if root then
      return "cd " .. vim.fn.shellescape(root) .. " && cargo build", "cd " .. vim.fn.shellescape(root) .. " && cargo run"
    end
    local b = "rustc -g " .. f .. " -o " .. o
    return b, b .. " && " .. o
  end

  -- C/C++: если есть проект (CMake/Makefile) — используем его
  if ft == "c" or ft == "cpp" then
    local mk = find_up("Makefile")
    if mk then
      local cd = "cd " .. vim.fn.shellescape(mk)
      return cd .. " && make", cd .. " && make && make run"
    end
    local cc = ft == "c" and "gcc -std=c17" or "g++ -std=c++23"
    local b = cc .. " -g -O0 -Wall -Wextra " .. f .. " -o " .. o
    return b, b .. " && " .. o
  end

  if ft == "nasm" then
    local obj = vim.fn.shellescape(out .. ".o")
    -- Если в файле есть main — линкуем через gcc (можно звать printf), иначе ld (_start)
    local has_main = vim.fn.search("\\<main\\>", "nw") > 0
    local link = has_main and ("gcc -no-pie -g " .. obj .. " -o " .. o) or ("ld " .. obj .. " -o " .. o)
    local b = "nasm -f elf64 -g -F dwarf " .. f .. " -o " .. obj .. " && " .. link
    return b, b .. " && " .. o
  end

  if ft == "asm" then -- GAS (.s / .S)
    local b = "gcc -g -no-pie " .. f .. " -o " .. o
    return b, b .. " && " .. o
  end
end

local function exec(which)
  vim.cmd("silent! wall")
  local build, run = commands()
  if not build then
    vim.notify("Не знаю, как собирать filetype=" .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  local cmd = which == "run" and run or build
  vim.cmd("botright 15split | terminal " .. cmd)
  vim.cmd("startinsert")
end

function M.run() exec("run") end
function M.build() exec("build") end

return M
