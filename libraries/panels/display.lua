
local config = require("libraries.panels.config")
local eventLib = require("libraries.eventLib")
local gnui = require("libraries.gnui")


---@alias panels.display.direction "HORIZONTAL" | "VERTICAL"

---@class panels.display
---@field page_history panels.page[]
---@field page panels.page?
---@field direction panels.display.direction
---@field display GNUI.container
---@field container GNUI.container
---@field margin number
---@field focused boolean
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
   new.display = gnui.newContainer():setSprite(config.default_display_sprite:copy())
   new.container = gnui.newContainer():setAnchor(0,0,1,1):setDimensions(2,2,-2,-2)
   new.display:addChild(new.container)
   new.focused = preset.focused or false
   setmetatable(new,display)
   return new
end

---@param p panels.page
---@param no_history boolean?
function display:setPage(p,no_history)
   if self.page ~= p then
      if not no_history then
         self.page_history[#self.page_history+1] = self.page
      end
      if self.page then
         self.page.display = nil
         self:detachDisplays()
      end
      self.page = p
      self:updateDisplays()
      self.page.display = self
   end
   return self
end

function display:returnPage()
   if #self.page_history > 0 then
      self:setPage(self.page_history[#self.page_history],true)
      self.page_history[#self.page_history] = nil
   end
   return self
end

---@param d panels.display.direction
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

---@package
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
         self.display:setDimensions(d.x,d.w-l,d.z,d.w)

      elseif false then -- unused inverted vertical
         local l = 0
         for _, e in pairs(self.page.elements) do
            self.container:addChild(e.display)
            e.display:setAnchor(0,1,1,1)
            local size = (e.display.ContainmentRect.w-e.display.ContainmentRect.y)
            local d = e.display.Dimensions
            l = l + (e.display.ContainmentRect.w-e.display.ContainmentRect.y)
            e.display:setDimensions(d.x,-l,d.z,-l+size)
         end
         local d = self.display.Dimensions
         local offset = self.container.Dimensions.y-self.container.Dimensions.w
         l = l + offset - 1
         self.display:setDimensions(d.x,d.w-l,d.z,d.w)
         
      elseif self.direction == "HORIZONTAL" then
         local l = 1
         local c = #self.page.elements
         for a, e in ipairs(self.page.elements) do
            local i = #self.page.elements-a
            self.container:addChild(e.display)
            e.display:setAnchor(i/c,0,(i+1)/c,1)
            e.display:setDimensions(0,0,0,0)
            l = math.max(l,e.display.ContainmentRect.w-1)
         end
         self.display:setDimensions(0,-14,0,0)
      end
   end
end
return display