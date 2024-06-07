extends Node
class_name MonsterSpwaner

@export var json_file: String

const SPAWNER = preload("res://Effects/SpwanEffect.tscn")

var export_table: Dictionary

var _data: Dictionary = {}

func _parse_json() -> Array:
	var file := FileAccess.open(json_file, FileAccess.READ)
	var content = file.get_as_text()
	return JSON.parse_string(content)

func _parse_data(data: Array):
	for object in data:
		var monsters = object["monsters"]
		var new_monsters = []
		for monster in monsters:
			var monster_object = {}
			monster_object["name"] = monster["name"]
			monster_object["position"] = Vector2(monster["position"][0], monster["position"][1])
			new_monsters.push_back(monster_object)
		var room_position := Vector2i(object["x"], object["y"])
		_data[room_position] = new_monsters

func load_data():
	var json = _parse_json()
	_parse_data(json)

func spawn_at_room(room: Vector2i, parent: Node2D):
	if room not in _data:
		return
	
	var monsters = _data[room]
	for monster in monsters:
		var monster_scene = export_table[monster["name"]]
		var spawner = SPAWNER.instantiate()
		spawner.spawned = monster_scene
		spawner.global_position = monster["position"]
		parent.add_child(spawner)
