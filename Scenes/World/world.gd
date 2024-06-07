extends Node2D

@onready var heart_container := $CanvasLayer/HeartsContainer
@onready var player := $Bedwill
@onready var monster_spawner := MonsterSpwaner.new()

const MONSTER_DATA = "res://Scenes/World/monsters.json"

func _ready():
	heart_container.set_max_hearts(player.max_health)
	player.health_changed.connect(heart_container.update_hearts)
	
	monster_spawner.json_file = MONSTER_DATA
	monster_spawner.load_data()
