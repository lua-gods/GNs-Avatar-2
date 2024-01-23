local is_holding_sword = false
local was_holding_sword

events.TICK:register(function ()
   is_holding_sword = (player:getHeldItem().id:find("sword") and true or false)
   if was_holding_sword ~= is_holding_sword then
      print(is_holding_sword)
      was_holding_sword = is_holding_sword
   end
end)