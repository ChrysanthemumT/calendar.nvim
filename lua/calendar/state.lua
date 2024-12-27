local M = {}

local CalendarState = {}
CalendarState.__index = CalendarState

function CalendarState.new()
    local calendar = os.date("*t")
    local self = {
        state = {
            day = calendar.day,
            month = calendar.month,
            year = calendar.year,
            wday = calendar.wday,
            yday = calendar.wday,
        },
        view = {
            day = calendar.day,
            month = calendar.month,
            year = calendar.year,
            wday = calendar.wday,
            yday = calendar.wday,
            view = "month"
        }
    }
    return setmetatable(self, CalendarState)
end

function CalendarState:next_month()
    if self.view.month == 12 then
        self.view.month = 1
        self.view.year = self.view.year + 1
    else
        self.view.month = self.view.month + 1
    end
end

function CalendarState:prev_month()
    if self.view.month == 1 then
        self.view.month = 12
        self.view.year = self.view.year - 1
    else
        self.view.month = self.view.month - 1
    end
end

function CalendarState:reset_view()
    self.view.day = self.state.day
    self.view.month = self.state.month
    self.view.year = self.state.year
    self.view.wday = self.state.wday
    self.view.yday = self.state.yday
end

function CalendarState:get_state()
    return self.view
end

M.CalendarState = CalendarState

return M
