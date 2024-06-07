extends Node2D

@onready var heart_container := $CanvasLayer/HeartsContainer
@onready var player := $Bedwill
@onready var monsters = $Monsters
@onready var monster_spawner := MonsterSpwaner.new()

const MONSTER_DATA = "res://Scenes/World/monsters.json"

const EXPORT_TABLE = {
	"spoink": preload("res://Characters/Monsters/Spoink/spoink.tscn")
}

func _ready():
	heart_container.set_max_hearts(player.max_health)
	player.health_changed.connect(heart_container.update_hearts)
	
	monster_spawner.json_file = MONSTER_DATA
	monster_spawner.export_table = EXPORT_TABLE
	monster_spawner.load_data()
	monster_spawner.spawn_at_room(Vector2.ZERO, monsters)
