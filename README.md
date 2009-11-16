About
------------
Little lua scipt that display album cover in conky.

Requirements
------------
* [lua filesystem](http://www.luaforge.net/projects/luafilesystem) 
* [imagemagick](http://www.imagemagick.org)

Under Ubuntu, just do:

    sudo apt-get install liblua5.1-filesystem0 imagemagick

How to use
------------
1. In the settings section (before TEXT), add this:
    * `lua_load /path/to/mpd_cover.lua`
2. modify mpd_cover.lua:
    * change `library_path = '/path/to/my/music'`
    * change `sonata_cover_path = '/path/to/sonata-covers'` (set it to nil if you dont use sonata)
    * set `no_cover_path = '/path/to/no-cover-image'` (image that is shown if cover not found)
3. add in TEXT section something like:
    `${if_mpd_playing}${lua_parse mpd_get_cover}${endif}`

just look at conkyrc-full-example

Screenshot
------------

![conky album cover](http://th09.deviantart.net/fs50/300W/i/2009/320/a/d/Cover_at_conky_by_kwargs.png "conky album cover")

[Full screen shot](http://kwargs.deviantart.com/art/Cover-at-conky-143790332 "Full screenshot")

