--
-- How to use:
-- In the settings section (before TEXT), add this:
--     lua_load /path/to/mpd_cover.lua
-- add in TEXT section something like:
--
-- ${if_mpd_playing}\
-- ${lua update_mpd_cover /path/where/store/found-cover /path/where/found/no-cover-image /path/to/music /path/to/sonata/covers/dir/if/you/use/it}\
-- ${image /path/where/store/found-cover -n -p2,2}
-- ${endif}
--
require "lfs"

local last = nil;
local cover_images = {'cover', 'folder', 'front'}

local function compare_images(current_album)
    return function (img_a, img_b)
        local function is_cover(img)
            local t = string.lower(img)
            local img_is_cover = nil
            for _, cover_t in ipairs(cover_images) do
                if string.find(t, cover_t) ~= nil then
                    return true
                end
            end
            if string.find(t, string.lower(current_album)) ~= nil then 
                return true
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
end

function conky_update_mpd_cover(cover_path, no_cover_path, library_path, sonata_covers_path)
    local album = conky_parse('${mpd_album}')
    local artist = conky_parse('${mpd_artist}')
    local current = string.lower(artist .. '-' .. album)

    if last == nil or last ~= current then
        local cover = nil;
        local song_path = conky_parse('${mpd_file}')
        if song_path ~= nil then
            local song_base = string.gsub(song_path, '[^/]-$', '')

            local images = {}
            for file in lfs.dir(library_path .. '/' .. song_base) do
                local t  = string.lower(file)
                if string.find(t, 'jpe?g$') ~= nil or string.find(t, 'png$') ~= nil then
                    table.insert(images, file)
                end
            end

            if #images > 0 then
                table.sort(images, compare_images(album))
                cover = unpack(images)
                cover = library_path .. '/' .. song_base .. cover
            end

            if cover == nil and sonata_covers_path ~= nil then
                for file in lfs.dir(sonata_covers_path) do
                    if string.find(string.lower(file), current, 1, true) ~= nil then
                        cover = sonata_covers_path .. '/' .. file
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
    return ""
end

