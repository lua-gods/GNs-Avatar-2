local config = {
   HUD = models:newPart("PanelHUD","HUD"),
   event = require("libraries.eventLib"),
   labelLib = require("libraries.GNLabelLib"),
   key2string = require("libraries.key2string"),
   uiSound = require("libraries.panelLib.utils.uiSound"),
   tween = require("libraries.GNTweenLib"),
   color_overrides = {
      hovering = {default = "white"},
      pressed = {default = "dark_gray"},
      none = {default = "gray"},
   },
   colors = {
      white = "#ffffff",
      black = "#000000",
      dark_blue = "#0000AA",
      dark_green = "#00AA00",
      dark_aqua = "#00AAAA",
      dark_red = "#AA0000",
      dark_purple = "#AA00AA",
      gold = "#FFAA00",
      gray = "#AAAAAA",
      dark_gray = "#555555",
      blue = "#5555FF",
      green = "#55FF55",
      aqua = "#55FFFF",
      red = "#FF5555",
      light_purple = "#FF55FF",
      yellow = "#FFFF55",
   },
}

return config