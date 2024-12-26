local M = {}

local dates = require("calendar.dates")

local Win_id, Title_id, Background_id
local augroup = vim.api.nvim_create_augroup("calendar", { clear = true })

vim.cmd([[
    highlight default Cursor guifg=NONE guibg=NONE blend=100
]])

local main = function()
    print("work on calendar")
    return 5
end

M.setup = function()
    vim.api.nvim_create_autocmd("VimEnter",
        { group = augroup, once = true, callback = main }
    )
end

CloseMenu = function()
    if Win_id and vim.api.nvim_win_is_valid(Win_id) then
        vim.api.nvim_win_close(Win_id, true)
        Win_id = nil
        if Title_id then
            vim.api.nvim_win_close(Title_id, true)
            Title_id = nil
        end
        if Background_id then
            vim.api.nvim_win_close(Background_id, true)
            Background_id = nil
        end
    end
end

local ShowMenu = function(cb)
    local width = vim.o.columns
    local height = vim.o.lines

    local body_buf = vim.api.nvim_create_buf(false, true)
    local background_buf = vim.api.nvim_create_buf(false, true)
    local title_buf = vim.api.nvim_create_buf(false, true)

    -- Calculate dimensions
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Window options
    local win_opts = {
        title_opts = {
            relative = 'editor',
            width = width,
            height = 1,
            col = 4,
            row = 0,
            style = 'minimal',
            border = 'rounded',
            zindex = 3
        },
        background_opts = {
            relative = 'editor',
            width = width,
            height = math.floor(height * 0.85),
            col = 0,
            row = 3,
            style = 'minimal',
            border = 'rounded',
            zindex = 1
        },
        body_opts = {
            relative = 'editor',
            width = width - 10,
            height = math.floor(height * 0.8),
            col = 5,
            row = 4,
            style = 'minimal',
            border = { " ", " ", " ", " ", " ", " ", " ", " ", },
            zindex = 5
        },
    }

    Background_id = Background_id or vim.api.nvim_open_win(background_buf, true, win_opts.background_opts)
    Title_id = Title_id or vim.api.nvim_open_win(title_buf, true, win_opts.title_opts)
    Win_id = Win_id or vim.api.nvim_open_win(body_buf, true, win_opts.body_opts)

    vim.api.nvim_win_set_option(
        Win_id,
        "winhl",
        "Normal:CalendarBorder"
    )
    vim.api.nvim_win_set_option(
        Background_id,
        "winhl",
        "Normal:CalendarBorder"
    )
    vim.api.nvim_win_set_option(
        Title_id,
        "winhl",
        "Normal:CalendarBorder"
    )

    vim.api.nvim_win_set_option(Win_id, "guicursor", "a:Cursor")
    vim.api.nvim_buf_set_keymap(body_buf, "n", "q", "<cmd>lua CloseMenu()<CR>", {
        silent = false })
    dates.show(body_buf)
    dates.set_date(title_buf)

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = body_buf,
        callback = CloseMenu
    })
    vim.api.nvim_buf_set_option(body_buf, 'modifiable', false)
end

M.toggle_on = function()
    local cb = function(_, sel)
        print("works!")
    end
    ShowMenu(cb)
end

return M
