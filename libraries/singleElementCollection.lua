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