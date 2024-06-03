
local config = require("libraries.panels.config")
local eventLib = require("libraries.eventLib")
local gnui = require("libraries.GNUI")


---@alias panels.display.style "HORIZONTAL" | "VERTICAL" | "HORIZONTAL_INDIVIDUAL"

---@class panels.display
---@field page_history panels.page[]
---@field page panels.page?
---@field direction panels.display.style
---@field display GNUI.container
---@field container GNUI.container
---@field margin number
---@field focused boolean
---@field PAGE_CHANGED eventLib
local display = {}
display.__index = function (t,i)
   return rawget(t,i) or display[i]
end
display.__type = "panels.container"

---@param preset panels.display?
---@return panels.display
function display.new(preset)
   preset = preset or {}
   local new = {}
   new.page = preset.page
   new.direction = preset.direction or "VERTICAL"
   new.margin = preset.margin or 1
   new.page_history = {}
   new.display = gnui.newContainer()
   new.container = gnui.newContainer():setAnchor(0,0,1,1):setDimensions(2,2,-2,-2)
   new.display:addChild(new.container)
   new.focused = preset.focused or false
   new.PAGE_CHANGED = eventLib.new()
   new.display.SIZE_CHANGED:register(function ()
      new:updateDisplays()
   end,"_internal_dislay")
   setmetatable(new,display)
   return new
end

---@param p panels.page
function display:setPage(p)
   if self.page ~= p then
      if self.page_history[#self.page_history] ~= p then
         self.page_history[#self.page_history+1] = p
      end
      if self.page then
         self.page:release()
         self.page.PRESSENCE_CHANGED:invoke(false)
         self.page.display = nil
      end
      if p then
         self:detachDisplays()
         self.page = p
         self.page.display = self
      end
      self.PAGE_CHANGED:invoke(self.page)
      self.page.PRESSENCE_CHANGED:invoke(true)
      self.page:setSelected(#self.page.elements)
      self:updateDisplays()
   end
   --print("+ ",self.page_history)
   return self
end

---@param remove_from_history boolean
---@return panels.page?
function display:getLastPage(remove_from_history)
   if #self.page_history > 0 then
      if remove_from_history then
         self.page_history[#self.page_history] = nil
      end
      return self.page_history[#self.page_history]
   end
end


function display:returnPage()
   --print("- ",self.page_history)
   self:setPage(self:getLastPage(true))
   return self
end

---@param d panels.display.style
function display:setDirection(d)
   self.direction = d
   self:updateDisplays()
   return self
end

---@package
function display:detachDisplays()
   if self.page then
      for _, e in pairs(self.page.elements) do
         e.display.Parent:removeChild(e.display)
      end
   end
end

function display:updateDisplays()
   if self.page then
      if self.direction == "VERTICAL" then
         local l = 0
         for _, e in pairs(self.page.elements) do
            self.container:addChild(e.display)
            e.display:setAnchor(0,0,1,0)
            local size = (e.display.ContainmentRect.w-e.display.ContainmentRect.y)
            local d = e.display.Dimensions
            e.display:setDimensions(d.x,l,d.z,l+size)
            l = l + (e.display.ContainmentRect.w-e.display.ContainmentRect.y)
         end
         local d = self.display.Dimensions
         local offset = self.container.Dimensions.y-self.container.Dimensions.w
         l = l + offset - 1
         self.display:setDimensions(d.x,d.w-l,d.z,d.w):setSprite(config.default_display_sprite:copy())
      elseif self.direction == "HORIZONTAL" or self.direction == "HORIZONTAL_INDIVIDUAL" then
         local c = #self.page.elements
         for a, e in ipairs(self.page.elements) do
            local p = a / c
            local i = 1 / c
            self.container:addChild(e.display)
            e.display:setAnchor(p-i,0,p ,1)
            e.label:setAlign(0.5,0.5)
            e.display:setDimensions(0,0,0,0)
            e.cache.borders = true
            e.HOVER_CHANGED:invoke() -- TODO: unprofessional patch
         end
         self.display:setDimensions(0,0,0,14):setAnchor(0,0,1,0)
      end
   end
end
return display