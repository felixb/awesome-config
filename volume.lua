-- volume widget

local volume = {}
local io = io

local function get_volume ()
    local fvol = io.popen("~/.config/awesome/bin/volume get")
    local vol = fvol:read()
    fvol:close()

    return vol
end

function volume.closure ()
    return function () return get_volume() end
end

return volume
