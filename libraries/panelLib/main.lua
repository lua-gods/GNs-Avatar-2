local API = {}

API.newPage = require("libraries.panelLib.page").new
API.newBook = require("libraries.panelLib.book").new

API.newButton = require("libraries.panelLib.elements.button.textButton").new
API.newToggleButton = require("libraries.panelLib.elements.button.toggleButton").new
API.newReturnButton = require("libraries.panelLib.elements.button.returnButton").new
API.newTextInputButton = require("libraries.panelLib.elements.button.textInputButton").new
API.newPageButton = require("libraries.panelLib.elements.button.pageButton").new

return API