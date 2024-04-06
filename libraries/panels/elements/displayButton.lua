
local eventLib = require("libraries.eventLib")
local config = require("libraries.panels.config")
local element = require("libraries.panels.element")
local button = require("libraries.panels.elements.button")

---@class panel.button.display : panel.button
---@field display_page panel.display
local displayButton = {}
displayButton.__index = function (t,i)
   return rawget(t,i) or displayButton[i] or button[i] or element[i]
end
displayButton.__type = "panel.button.display"

---@param preset panel.button.display?
---@return panel.button.display
function displayButton.new(preset)
   preset = preset or {}
   ---@type panel.button.display
   ---@diagnostic disable-next-line: assign-type-mismatch
   local new = button.new(preset)
   new.display_page = preset.display_page
   new._press_handler = function (pressed)
      if pressed and new.parent and new.display_page and new.display_page.page then
         new.parent:setProxyPage(new.display_page.page)
      end
   end
   new.PRESSED:register(function ()

   end,"_internal")
   events.MOUSE_SCROLL:register(function (dir)
      
   end,"panels.displayButton"..new.id.."_internal")
   return setmetatable(new,displayButton)
end

---@param d panel.display
---@return panel.button.display
function displayButton:setDisplay(d)
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
      d.display.SIZE_CHANGED:register(function () self:updateByPage()end,"_button_display")
   end
   return self
end

function displayButton:updateByPage()
   local d = self.display_page
   local s = d.display.ContainmentRect.w-d.display.ContainmentRect.y
      local c = self.display.Dimensions
      self.display:setDimensions(c.x,c.y,c.z,c.y+s)
end

-----@param d panel.display
-----@return panel.button.display
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