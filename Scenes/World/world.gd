extends Node2D

@onready var heart_container := $CanvasLayer/HeartsContainer
@onready var player := $Bedwill
@onready var monsters := $Monsters
@onready var camera := $RoomCamera
@onready var monster_spawner := MonsterSpwaner.new()

const MONSTER_DATA = "res://Scenes/World/monsters.json"
const FOREST_THEME = preload("res://Sounds/Music/Forest (main) theme.ogg")
const LEVEL_RESET = preload("res://Sounds/Sound Effects/level reset.wav")

const EXPORT_TABLE = {
	"spoink": preload("res://Characters/Monsters/Spoink/spoink.tscn")
}

func _ready():
	MusicController.play_music(FOREST_THEME)
	heart_container.set_max_hearts(player.max_health)
	player.health_changed.connect(heart_container.update_hearts)
	player.player_died.connect(_reload)
	
	camera.start_camera_transition.connect(_on_room_cleanup)
	camera.end_camera_transition.connect(_on_new_room)
	
	monster_spawner.json_file = MONSTER_DATA
	monster_spawner.export_table = EXPORT_TABLE
	monster_spawner.load_data()
	monster_spawner.spawn_at_room(Vector2.ZERO, monsters)
	
func _on_room_cleanup():
	for child in monsters.get_children():
		child.queue_free()

func _on_new_room(room: Vector2i):
	monster_spawner.spawn_at_room(room, monsters)

func _reload():
	MusicController.play_effect(LEVEL_RESET)
	get_tree().call_deferred("reload_current_scene")
