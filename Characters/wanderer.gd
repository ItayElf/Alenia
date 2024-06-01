extends Node
class_name Wanderer

var _is_active := true
var direction_timer: Timer
var current_direction := Vector2.ZERO

func _get_movement_direction() -> Vector2:
	var directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.ZERO
	]
	var random_direction = directions[randi() % directions.size()]
	return random_direction

func _on_timer_end():
	if not _is_active:
		current_direction = Vector2.ZERO
		return
	direction_timer.wait_time = randi() % 2 + 2
	current_direction = _get_movement_direction()
	direction_timer.start()

func _set_up_timer():
	direction_timer = Timer.new()
	direction_timer.connect("timeout", _on_timer_end)
	add_child(direction_timer)
	_on_timer_end()

func init():
	_set_up_timer()

func enable():
	_is_active = true
	_on_timer_end()

func disable():
	_is_active = false
	_on_timer_end()
