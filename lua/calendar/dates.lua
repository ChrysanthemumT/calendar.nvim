--TODO add dates
local M = {}

local get_calendar_data = function()
    local current_date = os.date("*t")
    local first_day = os.time({
        year = current_date.year,
        month = current_date.month,
        day = 1
    })
    local first_wday = os.date("*t", first_day).wday
    local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    if current_date.year % 4 == 0 and (current_date.year % 100 ~= 0 or current_date % 400 == 0) then
        days_in_month[2] = 29
    end

    return {
        year = current_date.year,
        month = current_date.month,
        day = current_date.day,
        first_wday = first_wday,
        days = days_in_month[current_date.month]
    }
end

M.show = function(bufnr)
    local cal = get_calendar_data()
    local lines = {}
    local highlights = {}
    local month_names = { "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December" }

    table.insert(lines, string.format("%s %d", month_names[cal.month], cal.year))
    table.insert(lines, "Su Mo Tu We Th Fr Sa")

    local current_line = ""
    local current_pos = 2
    local col_start = 0

    for i = 1, cal.first_wday - 1 do
        current_line = current_line .. "   "
        col_start = col_start + 3
    end

    for i = 1, cal.days do
        if i == cal.day then
            vim.schedule(function()
                vim.api.nvim_buf_add_highlight(bufnr, 0, "CurrentDay", current_pos,
                    col_start, col_start + 2)
            end)
        end
        current_line = current_line .. string.format("%2d ", i)
        col_start = col_start + 3
        if (i + cal.first_wday - 1) % 7 == 0 or i == cal.days then
            table.insert(lines, current_line)
            current_line = ""
            current_pos = current_pos + 1
            col_start = 0
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

M.show_date = function()
    get_calendar_data()
end

--vim.cmd [[highlight CurrentDay guibg=#3d59a1 guifg=#ffffff gui=bold]]

return M
