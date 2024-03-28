local gnui = require("libraries.gnui")
local screen = require("host.screenui")
local eventLib = require("libraries.eventLib")


local input = {
   pressed = false,
   keybind = keybinds:fromVanilla("figura.config.action_wheel_button")
}

input.keybind:onPress(function ()
   return true
end)

---@class panel.element
---@field child_order integer
---@field press function?
---@field released function?

---@class panel.page
---@field elements panel.element[]
---@field selected integer
---@field focused boolean
local page = {}

function page.new()
   local new = {
      elements = {},
      selected = 1,
      focused = false
   }
   return new
end

function page:sroll(x)
   local last_selected = self.selected
   self.selected = self.selected + x
   self.selected = math.clamp(self.selected, 1, #self.elements)

   return self
end