extends CharacterBody3D
class_name bunny
#signal bunny_picked_up
@export var is_picked_up : bool = false
@export var is_near_nest : bool = false
@export var is_nested : bool = false
@onready var label = $Label3D
@onready var statemachine = $StateMachine
@onready var scent = %scent

func _ready():
	if label:
		label.text = str(statemachine.current_state)

func initialize(_start_position, _player_position):
	_start_position.y = 0.0
	rotation_degrees.y = randf_range(0, 360)
	position = _start_position

func _physics_process(_delta):
	label.text = str(statemachine.current_state)
	scent.emitting = true

