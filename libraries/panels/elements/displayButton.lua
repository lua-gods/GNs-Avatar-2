local element = require("libraries.panels.element")
local button = require("libraries.panels.elements.button")

---@class panels.button.display : panels.button
---@field display_page panels.display
local displayButton = {}
displayButton.__index = function (t,i)
   return rawget(t,i) or displayButton[i] or button[i] or element[i]
end
displayButton.__type = "panels.button.display"


---@param preset panels.button.display?
---@return panels.button.display
function displayButton.new(preset)
   local a = 1 + "e"
   preset = preset or {}
   ---@type panels.button.display
   ---@diagnostic disable-next-line: assign-type-mismatch
   local new = button.new(preset)
   new.display_page = preset.display_page
   setmetatable(new,displayButton)
   return new
end


---@param d panels.display
---@generic self
---@param self self
---@return self
function displayButton:setDisplay(d)
   ---@cast self panels.button.display
   if self.display_page then
      self.display_page.display.SIZE_CHANGED:remove("_button_display")
      self.display:removeChild(self.display_page.display)
   end
   if d then
      self.display:addChild(d.display)
      self.display:setAnchor(0,1,1,1)
      d.display:setAnchor(0,1,1,1)
      self.display_page = d
      self:updateByPage()
      d.display.SIZE_CHANGED:register(function () self:updateByPage() end,"_button_display")
   end
   return self
end

function displayButton:press()
   if self.parent and self.display_page and self.display_page.page then
      self.parent:setProxyPage(self.display_page.page)
   end
end

function displayButton:updateByPage()
   local d = self.display_page
   local s = d.display.ContainmentRect.w-d.display.ContainmentRect.y
   local c = self.display.Dimensions
   self.display:setDimensions(c.x,c.y,c.z,c.y+s)
   self.custom_height = s
end

-----@param d panels.display
-----@return panels.button.display
--function displayButton:setDisplay(d)
--   if self.display_page then
--      self.display_page.display.DIMENSIONS_CHANGED:remove("_button_display")
--      self.display:removeChild(self.display_page.display)
--   end
--   if d then
--      local s = d.display.ContainmentRect.w-d.display.ContainmentRect.y
--      self.display:setDimensions(0,0,0,s)
--      self.display:addChild(d.display)
--      d.display:setAnchor(0,1,1,1)
--      d.display.SIZE_CHANGED:register(function ()
--         s = d.display.ContainmentRect.w-d.display.ContainmentRect.y
--         local c = d.display.Dimensions
--         self.display:setDimensions(0,0,0,s)
--      end)
--   end
--   return self
--end

return displayButton