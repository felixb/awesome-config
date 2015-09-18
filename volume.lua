-- volume widget

local io = io

module("volume")

function get_sink()
    local fp = io.popen('pactl list short sinks | grep analog | cut -f1 | head -n1')
    local sink = fp:read()
    fp:close()

    if (sink == '') then
        return '0'
    else
        return sink
    end
end

function get_volume (sink)
    local fvol = io.popen("pactl list sinks | perl -000ne 'if(/#"..sink.."/){/(Volume:.*)/; print \"$1\n\"}' | grep -o '[0-9]*%' | head -n1")
    local vol = fvol:read()
    fvol:close()

    local fmute = io.popen("pactl list sinks | perl -000ne 'if(/#"..sink.."/){/(Mute:.*)/; print \"$1\n\"}' | grep -oe yes -e no | head -n1")
    local mute = fmute:read()
    fmute:close()

    if mute == 'yes' then
        return '('..vol..')'
    else
        return vol
    end
end

function closure ()
    local sink = get_sink()
    return function () return get_volume(sink) end
end
