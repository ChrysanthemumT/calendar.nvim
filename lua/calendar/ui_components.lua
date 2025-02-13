M = {}

M.create_day_box = function(day)
    if type(day) == "number" then
        return {
            "┌───────────────┐",
            string.format("│             %2d│", day),
            "│               │",
            "└───────────────┘"
        }
    else
        return {
            "┌───────────────┐",
            "│               │",
            "│               │",
            "└───────────────┘"
        }
    end
end

M.create_week_label = function()
    return {
        "┌───────────────┐┌───────────────┐┌───────────────┐┌───────────────┐┌───────────────┐┌───────────────┐┌───────────────┐",
        "│     Sunday    ││     Monday    ││    Tuesday    ││    Wednesday  ││    Thursday   ││     Friday    ││    Saturday   │",
        "└───────────────┘└───────────────┘└───────────────┘└───────────────┘└───────────────┘└───────────────┘└───────────────┘",
    }
end


return M
