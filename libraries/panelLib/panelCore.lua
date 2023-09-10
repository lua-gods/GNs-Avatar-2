local config = {
   HUD = models:newPart("PanelHUD","HUD"),
   event = require("libraries.KattEventsAPI"),
   labelLib = require("libraries.GNLabelLib"),
   uiSound = require("libraries.panelLib.utils.uiSound"),
   color_overrides = {
      hovering = {default = "white"},
      pressed = {default = "dark_gray"},
      none = {default = "gray"},
   },
}

return config