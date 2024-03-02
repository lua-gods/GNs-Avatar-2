
---@param gnui GNUI
---@param events GNUI.TV.app
---@param screen GNUI.container
---@param skull WorldSkull
local function new(gnui,screen,events,skull)
   
end
avatar:store("gnui.app.ee",{
   update = client:getSystemTime(),
   name   = "Not Calcul",
   new    = new,
   icon   = textures["textures.icons"],
   icon_atlas_pos = vectors.vec2(0,0)
})

--avatar:store("gnui.force_app","system:template")
--avatar:store("gnui.debug",true)
--avatar:store("gnui.force_app",client:getViewer():getUUID()..":template")
