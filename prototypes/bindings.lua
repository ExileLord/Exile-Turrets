local bindings = require("lib.Bindings")

data:extend({
    {
      type = "custom-input",
      name = bindings.open_leaderboard_gui,
      key_sequence = "CTRL + SHIFT + T",
      consuming = "script-only"
    }
  })