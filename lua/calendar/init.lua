local M = {}

local augroup = vim.api.nvim_create_augroup("calendar", { clear = true })

local main = function()
    print("work on calendar!!")
    return 5
end

local create_buf = function()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, "*calendar*")
    vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
    return buf
end

local buf = create_buf()

--[[
vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "-- Welcome to Neovim!", "" })
vim.api.nvim_win_set_buf(0, buf)
vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
--]]

M.setup = function()
    vim.api.nvim_create_autocmd("VimEnter",
        { group = augroup, once = true, callback = main }
    )
end


return M
