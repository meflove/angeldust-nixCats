--[[
NOTE:
if you plan to always load your nixCats via nix,
you can safely ignore this setup call.
Unless you want the lzUtils file, or the lazy wrapper, you also wont need lua/nixCatsUtils

IF YOU DO NOT DO THIS SETUP CALL:
the result will be that, when you load this folder without using nix,
the global nixCats function which you use everywhere
to check for categories will throw an error.
This setup function will give it a default value.
Of course, if you only ever download nvim with nix, this isnt needed.]]
--[[ ----------------------------------- ]]
--[[ This setup function will provide    ]]
--[[ a default value for the nixCats('') ]]
--[[ function so that it will not throw  ]]
--[[ an error if not loaded via nixCats  ]]
--[[ ----------------------------------- ]]
require("nixCatsUtils").setup({
  non_nix_value = true,
})

--[[
outside of when you want to use the nixCats global command
to decide if something should be loaded, or to pass info from nix to lua,
thats pretty much everything specific to nixCats that
needs to be in your config.
--]]

--[[
ok thats enough for 1 file. Off to lua/myLuaConf/init.lua
all the config starts there in this example config.
This config is loaded via nix.
the rest is just example of how to configure nvim making use of various
features of nixCats and using the plugin lze for lazy loading.
--]]
require("myLuaConf")
