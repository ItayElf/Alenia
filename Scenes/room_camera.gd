extends Camera2D

@export var player: Player
@export var transition_offset: Vector4i = Vector4i(4,6,4,4)

@onready var camera_size: Vector2i = get_viewport_rect().size

var current_cell: Vector2i

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
	global_position = current_cell * camera_size

func _ready():
	current_cell = Vector2i(player.get_global_center_position()) / camera_size
	update_position()

func _physics_process(delta):
	var old_cell = current_cell
	update_cell()
	
	if old_cell != current_cell:
		update_position()
		player.clamp_to_limits(global_position, camera_size)
