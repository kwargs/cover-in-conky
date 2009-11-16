
local status_conv = {
    Playing = '▶',
    Paused = '❚❚',
    Stopped ='■'
}

function conky_mpd_status_char()
    local mpd_status = conky_parse('${mpd_status}')
    return status_conv[mpd_status] or mpd_status;
end

function conky_strip(fields, max_length)
    max_length = tonumber(max_length)
    local str = conky_parse(fields)
    if #str > max_length then
        str = string.sub(str, 1, max_length -3) .. '...'
    end
    return str
end

function conky_flood(len, field, interface)
    local str = conky_parse('${' .. field .. ' ' .. interface .. '}')
    return str .. string.rep(" ", tonumber(len) - #str)
end

