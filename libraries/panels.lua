--[[______   __
  / ____/ | / / By: GNamimates
 / / __/  |/ / Panels Alpha
/ /_/ / /|  / A High level extension to the GNUI library for figura for quick settings.
\____/_/ |_/ https://github.com/lua-gods/GNs-Avatar-2/tree/main/libraries/panels.lua]]

local single = require("libraries.singleElementCollection")
local multi = require("libraries.panels.multiElementCollection")

--- for static annotation :(
local combined = {}
combined.newElement = single.newElement
combined.newButton = single.newButton
combined.newToggle = single.newToggle
combined.newDisplayButton = single.newDisplayButton
combined.newPage = single.newPage
combined.newDisplay = single.newDisplay
combined.newTextEdit = single.newTextEdit
combined.newSpinbox = single.newSpinbox
combined.newVector3Button = multi.newVector3Button

return combined