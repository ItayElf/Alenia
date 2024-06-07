extends Camera2D

@export var player: Player
@export var speed := 3
@export var transition_offset: Vector4i = Vector4i(0,0,0,0)

@onready var camera_size: Vector2i = get_viewport_rect().size

signal entered_new_room(new_room: Vector2i)

var current_cell: Vector2i
var target_position: Vector2i
var should_move = false

func update_cell():
	var player_center = player.get_global_center_position()
	
	var cell_direction := Vector2i.ZERO
	if player_center.x < global_position.x + transition_offset.x:
		cell_direction.x = -1
	elif player_center.x > global_position.x + camera_size.x - transition_offset.y:
		cell_direction.x = 1
	elif player_center.y < global_position.y + transition_offset.z:
		cell_direction.y = -1
	elif player_center.y > global_position.y + camera_size.y - transition_offset.w:
		cell_direction.y = 1
	
	current_cell += cell_direction

func update_position():
	target_position = current_cell * camera_size
	should_move = true

func is_slide_over():
	if not should_move: return false
	#global_position.is_equal_approx(Vector2(target_position))
	var diff := (Vector2(target_position) - global_position).abs()
	return diff.x < speed and diff.y < speed

func _ready():
	current_cell = Vector2i(player.get_global_center_position()) / camera_size
	update_position()

func _physics_process(_delta):
	var old_cell = current_cell
	update_cell()
	
	if old_cell != current_cell:
		update_position()
		player.can_move = false
		entered_new_room.emit(current_cell)
	
	var slide_direction = global_position.direction_to(target_position).normalized()
	global_position += slide_direction * speed
	
	if is_slide_over():
		global_position = target_position
		should_move = false
		player.can_move = true
		player.clamp_to_limits(global_position, camera_size)
