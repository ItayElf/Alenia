extends Node2D

@onready var heart_container := $CanvasLayer/HeartsContainer
@onready var player := $Bedwill

func _ready():
	heart_container.set_max_hearts(player.max_health)
	player.health_changed.connect(heart_container.update_hearts)
