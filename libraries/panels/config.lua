local gnui = require("libraries.gnui")
local screen = require("host.screenui")

local config = {
   default_display_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(0,0,4,4):setBorderThickness(2,2,2,2),
   default_display_sprite_borderless = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(1,10,3,12):setBorderThickness(1,1,1,1),
   
   default_element_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(5,2,13,4):setBorderThickness(3,1,3,1),
   default_element_hover_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(6,1),
   default_element_pressed_sprite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(6,1):setColor(0,0,0),
   
   generic_ninepatch_srite = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(1,6,3,8):setBorderThickness(1,1,1,1),
   generic_ninepatch_srite_border = gnui.newSprite():setTexture(textures["textures.ui"]):setUV(0,14,4,18):setBorderThickness(2,2,2,2),
}

return config