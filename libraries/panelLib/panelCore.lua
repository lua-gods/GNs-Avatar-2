local config = {
   HUD = models:newPart("PanelHUD","HUD"),
   event = require("libraries.eventLib"),
   labelLib = require("libraries.GNLabelLib"),
   uiSound = require("libraries.panelLib.utils.uiSound"),
   json = require("libraries.panelLib.utils.json"),
   color_overrides = {
      hovering = {default = "white"},
      pressed = {default = "dark_gray"},
      none = {default = "gray"},
   },
}

return config