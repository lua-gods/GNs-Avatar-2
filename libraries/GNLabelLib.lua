---@diagnostic disable: undefined-field
--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]

local config = {
   defualt_parent = models:newPart("LabelHUD","HUD")
}

---@alias Label.Effect string
---| "NONE"
---| "SHADOW"
---| "OUTLINE"

local next_free = 0
---@class Label
---@field ID string
---@field Text string
---@field TextOverride table?
---@field RenderTask TextTask
---@field Parent ModelPart
---@field Position Vector3
local Label = {}
Label.__index = Label
Label.__type = "label"

---@param parent ModelPart?
---@return Label
function Label.new(parent)
   local id = "labellib"..tostring(next_free)
   local new = {}
   new.Text = "Untitled"
   new.Position = vectors.vec3()
   new.Parent = parent or config.defualt_parent
   new.RenderTask = new.Parent:newText(id):setText(new.Text)
   new.ID = id
   setmetatable(new,Label)
   next_free = next_free + 1
   return new
end

function Label:delete()
   self.Parent:removeTask(self.ID)
end

function Label:setTextOverrides(overrides)
   self.TextOverride = overrides
   self:setText(self.Text)
   return self
end

---@param text string
---@return Label
function Label:setText(text)
   if self.TextOverride then
      for what, with in pairs(self.TextOverride) do
         text = text:gsub(what,with)
      end
   end
   self.Text = text
   self.RenderTask:setText(text)
   return self
end

---@param rclr number|Vector3
---@param g number
---@param b number
---@return Label
function Label:setGlowColor(rclr,g,b)
   local t = type(rclr)
   if t == "Vector3" then
      self.RenderTask:setOutlineColor(rclr)
   else
      self.RenderTask:setOutlineColor(rclr,g,b)
   end
   return self
end


---@param type Label.Effect
function Label:setEffect(type)
   self.RenderTask:setShadow(type == "SHADOW")
   self.RenderTask:setOutline(type == "OUTLINE")
   return self
end

---@param x number|Vector2
---@param y number?
---@return Label
function Label:setPos(x,y)
   local t = type(x)
   if t == "Vector2" then
      self.Position = vectors.vec3(x.x,x.y,self.Position.z)
   elseif t == "number" then
      self.Position = vectors.vec3(x,y,self.Position.z)
   end
   self.RenderTask:pos(self.Position.x,self.Position.y,self.Position.z)
   return self
end


---@param z number
---@return Label
function Label:setDepth(z)
   self.Position.z = z
   self:setPos(self.Position.x,self.Position.y)
   return self
end

return Label