extends Node
class_name MonsterSpwaner

@export var json_file: String

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
	print_debug(_data)
