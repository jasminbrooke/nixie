extends CharacterBody3D
class_name raccoon

@onready var label = $raccoon_label
@onready var statemachine = $StateMachine
@onready var player = get_node("../../World/Nixie")
@onready var raccoon_label = $raccoon_label
var speed = 5.0
var rotation_speed = 5.0

func _ready():
	if label:
		label.text = str(statemachine.current_state)
	
func _physics_process(_delta: float) -> void:
	position.y = 0.0
	move_and_slide()
	label.text = str(statemachine.current_state)

