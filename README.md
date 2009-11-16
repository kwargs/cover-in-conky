About
------------
Little lua scipt that display album cover in conky.

Requirements
------------
`lua filesystem` (http://www.luaforge.net/projects/luafilesystem) 
`imagemagick` (http://www.imagemagick.org)
Under Ubuntu, just do:

    sudo apt-get install liblua5.1-filesystem0 imagemagick

How to use
------------
In the settings section (before TEXT), add this:
    lua_load /path/to/mpd_cover.lua
modify mpd_cover.lua:
    change library_path
    sonata_cover_path (set it to nil if you don't use sonata)
    no_cover_path (image that is shown if cover not found)

add in TEXT section something like:
    ${if_mpd_playing}${lua_parse mpd_get_cover}${endif}

Screenshot
------------

![conky album cover](http://th09.deviantart.net/fs50/300W/i/2009/320/a/d/Cover_at_conky_by_kwargs.png "conky album cover")

http://kwargs.deviantart.com/art/Cover-at-conky-143790332

