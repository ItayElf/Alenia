extends Panel

@onready var sprite = $Sprite2D

func update(new_health: float):
	if new_health == 1:
		sprite.frame = 0
	elif new_health == 0:
		sprite.frame = 2
	else:
		sprite.frame = 1
