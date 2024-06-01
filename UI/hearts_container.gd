extends HBoxContainer

@onready var HeartUI = preload("res://UI/heart_ui.tscn")

func set_max_hearts(max_hearts: int):
	for i in range(max_hearts):
		var heart := HeartUI.instantiate()
		add_child(heart)

func update_hearts(current_health: float):
	var hearts := get_children()
	hearts.reverse()
	
	for i in range(int(current_health)):
		hearts[i].update(1)
	
	hearts[int(current_health)].update(current_health - int(current_health))
	
	for i in range(int(current_health)+1, hearts.size()):
		hearts[i].update(0)
