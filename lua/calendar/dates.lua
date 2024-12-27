local components = require("calendar.ui_components")
local M = {}

vim.cmd([[
  highlight default CurrentDay guibg=#3d59a1 guifg=#ffffff gui=bold
  highlight default MyHighlight guibg=#98FB98 guifg=#ffffff gui=bold
]])

local MONTHS = { "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" }

local state = {
    current_day = {},
    current_month = {},
}

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
    local ns_id = vim.api.nvim_create_namespace('calendar_highlights')

    -- Add header
    --table.insert(lines, string.format("%s %d", MONTHS[cal.month], cal.year))
    --table.insert(lines, "")

    -- Build calendar grid
    local box_height = 5
    local current_week = {}

    for i = 1, 3 do
        table.insert(lines, components.create_week_label()[i]);
    end

    for i = 1, box_height do
        current_week[i] = ""
    end

    -- Add initial padding
    for i = 1, cal.first_wday - 1 do
        local empty_box = components.create_day_box("  ")
        for j = 1, box_height do
            current_week[j] = current_week[j] .. empty_box[j]
        end
    end

    -- Add days
    for i = 1, cal.days do
        local day_box = components.create_day_box(i)

        if i == 1 then
            for line_offset = 1, 4 do
                table.insert(highlights, {
                    line = #lines + line_offset,    -- +2 for header lines
                    col_start = #current_week[1],
                    col_end = #current_week[1] + 12 -- Box width
                })
            end
        end

        for j = 1, box_height do
            current_week[j] = current_week[j] .. day_box[j]
        end

        if (i + cal.first_wday - 1) % 7 == 0 then
            for j = 1, box_height do
                table.insert(lines, current_week[j])
            end
            current_week = {}
            for j = 1, box_height do
                current_week[j] = ""
            end
        end
    end

    -- Add remaining days
    if current_week[1] ~= "" then
        for j = 1, box_height do
            table.insert(lines, current_week[j])
        end
    end

    -- Set buffer content and highlights
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    -- Apply highlights
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    --[[for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(bufnr, ns_id, 'CurrentDay',
            hl.line, hl.col_start, hl.col_end)
        print(vim.inspect({ hl.line, hl.col_start, hl.col_end }))
    end
    --]]
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
end

M.set_date = function(bufnr)
    local lines = {}
    local cal = get_calendar_data()
    local date = string.format("%s %d", MONTHS[cal.month], cal.year)
    local width = (vim.o.columns - #date) / 2
    local padding = string.rep(" ", width)
    table.insert(lines, padding .. date)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-- Optional: Add navigation methods
function M.next_month()
    -- Implementation for moving to next month
end

function M.prev_month()
    -- Implementation for moving to previous month
end

return M
