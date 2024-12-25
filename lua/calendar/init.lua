local M = {}

local popup = require("plenary.popup")

local Win_id

local augroup = vim.api.nvim_create_augroup("calendar", { clear = true })

local main = function()
    print("work on calendar!!")
    return 5
end

M.setup = function()
    vim.api.nvim_create_autocmd("VimEnter",
        { group = augroup, once = true, callback = main }
    )
end

CloseMenu = function()
    vim.api.nvim_win_close(Win_id, true)
end

local ShowMenu = function(opts, cb)
    local parent_win = vim.api.nvim_get_current_win()
    local width = math.floor(vim.api.nvim_win_get_width(parent_win) * 0.9)
    local height = math.floor(vim.api.nvim_win_get_height(parent_win) * 0.9)
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    Win_id = popup.create(opts, {
        title = "Calendar",
        highlight = "CalendarHighlight",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
    })
    local bufnr = vim.api.nvim_win_get_buf(Win_id)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", {
        silent = false })
end

M.toggle_on = function()
    local opts = {}
    local cb = function(_, sel)
        print("works!")
    end
    ShowMenu(opts, cb)
end

return M
