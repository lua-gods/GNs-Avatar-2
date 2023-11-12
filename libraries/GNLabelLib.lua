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
---@field Align Vector2
local Label = {}
Label.__index = Label
Label.__type = "label"

---@param parent ModelPart?
---@return Label
function Label.new(parent)
   local id = "labellib"..tostring(next_free)
   local new = {}
   new.Text = ""
   new.Position = vectors.vec3()
   new.Align = vectors.vec2(-1,1)
   new.Dimensions = vectors.vec2(0,0)
   new.Parent = parent or config.defualt_parent
   new.RenderTask = new.Parent:newText(id)
   new.ID = id
   setmetatable(new,Label)
   new:setText("Untitled")
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
   self.Dimensions = vectors.vec2(
      client.getTextWidth(text),
      client.getTextHeight(text)
   )
   self:setPos(self.Position.xy)
   self.RenderTask:setText(text)
   return self
end

---@param visible boolean
---@return Label
function Label:setVisible(visible)
   self.Visible = visible
   self.RenderTask:setVisible(visible)
   return self
end

--- -1 = left, 0 = center, 1 = right
---@param x number|Vector2
---@param y number?
---@return Label
function Label:setAlign(x,y)
   if type(x) == "Vector2" then
      self.Align = x
   else
      self.Align = vectors.vec2(x,y)
   end
   self:setPos(self.Position.xy)
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

---@param x number|Vector2|Vector3
---@param y number?
---@param z number?
---@return Label
function Label:setPos(x,y,z)
   local t = type(x)
   if t == "Vector2" then
      self.Position = vectors.vec3(x.x or 0,x.y or 0,self.Position.z)
   elseif t == "Vector3" then
      self.Position = x:copy()
   elseif t == "number" then
      self.Position = vectors.vec3(x or 0,y or 0,z or self.Position.z)
   end
   self.RenderTask:pos(
      self.Position.x + self.Dimensions.x * ((self.Align.x + 1) * 0.5),
      self.Position.y + self.Dimensions.y * ((self.Align.y + 1) * 0.5),
      self.Position.z)
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