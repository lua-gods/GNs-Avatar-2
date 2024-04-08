--[[______   __                _                 __
  / ____/ | / /___ _____ ___  (_)___ ___  ____ _/ /____  _____
 / / __/  |/ / __ `/ __ `__ \/ / __ `__ \/ __ `/ __/ _ \/ ___/
/ /_/ / /|  / /_/ / / / / / / / / / / / / /_/ / /_/  __(__  )
\____/_/ |_/\__,_/_/ /_/ /_/_/_/ /_/ /_/\__,_/\__/\___/____]]

---@alias panels.any panels.element | panels.button | panels.toggle | panels.display | panels.textInput

return {
   newElement = require("libraries.panels.element").new,
   newButton = require("libraries.panels.elements.button").new,
   newToggle = require("libraries.panels.elements.toggle").new,
   newDisplayButton = require("libraries.panels.elements.displayButton").new,
   newPage = require("libraries.panels.page").new,
   newDisplay = require("libraries.panels.display").new,
   newTextEdit = require("libraries.panels.elements.textInput").new,
   newSpinbox = require("libraries.panels.elements.spinbox").new,
}