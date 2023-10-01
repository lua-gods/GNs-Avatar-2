local API = {}

API.newPage = require("libraries.panelLib.page").new
API.newBook = require("libraries.panelLib.book").new

API.newButton = require("libraries.panelLib.elements.textButton").new
API.newToggleButton = require("libraries.panelLib.elements.toggleButton").new
API.newReturnButton = require("libraries.panelLib.elements.returnButton").new
API.newTextInputButton = require("libraries.panelLib.elements.textInputButton").new

return API