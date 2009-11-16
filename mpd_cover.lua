--
-- How to use:
-- In the settings section (before TEXT), add this:
--     lua_load /path/to/mpd_cover.lua
-- modify mpd_cover.lua:
--     change library_path
--     sonata_cover_path (set it to nil if you don't use sonata)
--     no_cover_path (image that is shown if cover not found)
-- add in TEXT section something like:
--
-- ${if_mpd_playing}${lua_parse mpd_get_cover}${endif}
--
require "lfs"

library_path = '/home/wizard/music/'
sonata_covers_path = '/home/wizard/.covers/'
no_cover_path = '/home/wizard/music/no_cover.jpg'
cover_path = '~/tmp/conky-cover.jpg'

local last = nil;
local cover_images = {'cover', 'folder', 'front'}

local function compare_images(img_a, img_b)
    local function is_cover(img)
        local t = string.lower(img)
        local img_is_cover = nil
        for _, cover_t in ipairs(cover_images) do
            if string.find(t, cover_t) ~= nil then
                return true
            end
        end
        return false
    end

    local a_is_cover = is_cover(img_a)
    local b_is_cover = is_cover(img_b)

    local res = img_a < img_b
    if a_is_cover and (not b_is_cover) then
        res =  false
    elseif (not a_is_cover) and b_is_cover then
        res = true 
    end
    return not res
end

function conky_mpd_get_cover()
    local current = string.lower(conky_parse('${mpd_artist}-${mpd_album}'))

    if last == nil or last ~= current then
        local cover = nil;
        local song_path = conky_parse('${mpd_file}')
        if song_path ~= nil then
            local song_base = string.gsub(song_path, '[^/]-$', '')

            local images = {}
            for file in lfs.dir(library_path .. song_base) do
                local t  = string.lower(file)
                if string.find(t, 'jpe?g') ~= nil or string.find(t, 'png$') ~= nil then
                    table.insert(images, file)
                end
            end

            if #images > 0 then
                table.sort(images, compare_images)
                cover = unpack(images)
                cover = library_path .. song_base .. cover
            end

            if cover == nil and sonata_covers_path ~= nil then
                for file in lfs.dir(sonata_covers_path) do
                    if string.find(string.lower(file), current, 1, true) ~= nil then
                        cover = sonata_covers_path .. file
                        break
                    end
                end
            end
        end

        if cover == nil then cover = no_cover_path end

        cover = string.gsub(cover, "([%s\(\)&'\$])", '\\%1')
        os.execute('convert ' .. cover .. ' -thumbnail 100x100 ' .. cover_path)

        last = current
    end
    return '${image ' .. cover_path .. ' -n -p 2,2}'
end

