extends CharacterBody3D
class_name bunny

@export var is_picked_up : bool = false
@export var is_near_nest : bool = false
@export var is_nested : bool = false
@onready var label = $Label3D
@onready var statemachine = $StateMachine
@onready var scent = %scent
@onready var player = get_node("../../World/Nixie")  # Use ".." to go up one level and then specify the node name
@onready var nested = $StateMachine/nested

func _ready():
	if label:
		label.text = str(is_picked_up)
		#label.text = str(statemachine.current_state)
		
func initialize(_start_position, _player_position):
	_start_position.y = 0.0
	rotation_degrees.y = randf_range(0, 360)
	position = _start_position

func _physics_process(_delta):
	label.text = str(is_picked_up)
