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
2. add in TEXT section something like:

    ${if_mpd_playing}\
    ${lua update_mpd_cover /path/where/store/found-cover /path/where/found/no-cover-image /path/to/music /path/to/sonata/covers/dir/if/you/use/it}\
    ${image /path/where/store/found-cover -n -p2,2}
    ${endif}

just look at conkyrc-full-example

Screenshot
------------

![conky album cover](http://github.com/kwargs/cover-in-conky/raw/master/screenshot.png "conky album cover")

[Full screen shot](http://kwargs.deviantart.com/art/Cover-at-conky-143790332 "Full screenshot")

