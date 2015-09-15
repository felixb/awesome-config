-- volume widget

local io = io

module("volume")

function get_volume ()
    local fvol = io.popen("pactl list sinks | grep Volume | grep -o '[0-9]*%' | head -n1")
    local vol = fvol:read()
    fvol:close()

    local fmute = io.popen("pactl list sinks | grep Mute | grep -oe yes -e no")
    local mute = fmute:read()
    fmute:close()

    if mute == 'yes' then
        return '('..vol..')'
    else
        return vol
    end
end


function volume_closure ()
    return function () return get_volume() end
end
