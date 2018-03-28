local turret_flying_text = table.deepcopy(data.raw["flying-text"]["flying-text"])

turret_flying_text.name = "turret-flying-text"
turret_flying_text.speed = 0.00
turret_flying_text.text_alignment = "center"
turret_flying_text.time_to_live = 600

data:extend{turret_flying_text}