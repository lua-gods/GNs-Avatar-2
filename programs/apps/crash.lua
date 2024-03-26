
---@param gnui GNUI
---@param events GNUI.TV.app
---@param screen GNUI.container
---@param skull WorldSkull
local function new(gnui,screen,events,skull)
   models:deeznuts()
end

avatar:store("gnui.app.crash",{
   update = client:getSystemTime(),
   name   = "Crash",
   new    = new,
   icon   = textures["textures.icons"],
   icon_atlas_pos = vectors.vec2(1,0)
})

--avatar:store("gnui.force_app","system:template")
--avatar:store("gnui.debug",true)
--avatar:store("gnui.force_app",client:getViewer():getUUID()..":template")
