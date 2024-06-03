local sidebar = require("host.contextMenu")
local element = require("libraries.panels")
local page = element.newPage()

local lineLib = require("libraries.GNLineLib")

---@class SelectionCube

return function ()
   local e = {
      element.newButton():setText("replace 0 with item"):pressed(function ()host:sendChatCommand("//replace 0 "..player:getHeldItem().id)end),
      element.newButton():setText("Set from item"):pressed(function ()host:sendChatCommand("//set "..player:getHeldItem().id)end),
      element.newButton():setText("Copy Selection  "):pressed(function () host:sendChatCommand("//copy") end),
         element.newButton():setText("flip n paste"):pressed(function ()
         host:sendChatCommand("//flip")
         host:sendChatCommand("//pa")
      end),
      element.newButton():setText("Extrude"):pressed(function ()host:sendChatCommand("//stack")end),
      element.newButton():setText("Undo"):pressed(function ()host:sendChatCommand("//undo")end),
      element.newButton():setText("Redo"):pressed(function ()host:sendChatCommand("//redo")end),
   }
   page:addElement(table.unpack(e))
   page:addElement(sidebar.newReturnButton())
   return page
end