local turretFlyingText = table.deepcopy(data.raw["flying-text"]["flying-text"])

turretFlyingText.name = "turret-flying-text"
turretFlyingText.speed = 0.00
turretFlyingText.text_alignment = "center"
turretFlyingText.time_to_live = 600

data:extend{turretFlyingText}