-- battery widget: http://awesome.naquadah.org/wiki/Closured_Battery_Widget_with_time

local io = io
local math = math
local naughty = naughty
local beautiful = beautiful
local tonumber = tonumber
local tostring = tostring
local print = print
local pairs = pairs

module("battery")

local limits = {{25, 5},
          {12, 3},
          { 7, 1},
            {0}}

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function get_adapters()
    local adapters = {'BAT0', 'BAT1'}
    local found_adapters = {}
    local c = 1
    for i=1, #adapters do
        if file_exists("/sys/class/power_supply/"..adapters[i].."/status") then
	    found_adapters[c] = adapters[i]
	    c = c + 1
	end
    end
    return found_adapters
end

function get_bat_state (adapter)
    local adapter_path = "/sys/class/power_supply/"..adapter
    local fprefix = ""
    if file_exists(adapter_path.."/energy_now") then
        fprefix = "energy"
    else
        fprefix = "charge"
    end
    local fcur = io.open(adapter_path.."/"..fprefix.."_now")
    local fcap = io.open(adapter_path.."/"..fprefix.."_full")
    local fsta = io.open(adapter_path.."/status")
    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    fcur:close()
    fcap:close()
    fsta:close()

    local battery = math.floor(cur * 100 / cap)
    if sta:match("Charging") then
        dir = 1
    elseif sta:match("Discharging") then
        dir = -1
    else
        dir = 0
    end
    return battery, dir
end

function get_bat_time ()
    local facp = io.popen("acpi -b")
    local acp = facp:read()
    facp:close()

    if acp:match('remaining') then
        local idx = acp:find('remaining')
        local time = acp:sub(idx - 8, idx - 5)
        return time
    else
        return ''
    end
end

function getnextlim (num)
    for ind, pair in pairs(limits) do
        lim = pair[1]; step = pair[2]; nextlim = limits[ind+1][1] or 0
        if num > nextlim then
            repeat
                lim = lim - step
            until num > lim
            if lim < nextlim then
                lim = nextlim
            end
            return lim
        end
    end
end

function batclosure ()
    local adapters = get_adapters()
    local nextlim = limits[1][1]
    return function ()
        local prefix = "⚡"
	local time = get_bat_time()
        local batteries = ""
        for i=1, #adapters do
            adapter = adapters[i]
            local battery, dir = get_bat_state(adapter)
            if dir == -1 then
                dirsign = "▼"
                prefix = "Bat: "
                prefix = prefix .. time
                if battery <= nextlim then
                    naughty.notify({title = "⚡ Beware! ⚡",
                                text = "Battery charge is low ( ⚡ "..battery.."%)!",
                                timeout = 7,
                                position = "bottom_right",
                                fg = beautiful.fg_focus,
                                bg = beautiful.bg_focus
                                })
                    nextlim = getnextlim(battery)
                end
            elseif dir == 1 then
                dirsign = "▲"
                nextlim = limits[1][1]
            else
                dirsign = ""
            end
            battery = battery.."%"
            batteries = batteries..dirsign.." "..battery.." "
        end
        return " "..prefix.." "..batteries
    end
end
