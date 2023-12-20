extends State
class_name nixierun
@onready var nixie = $"../.."
@onready var run_speed = 9
@onready var anim_tree = $"../../AnimationTree"


# Called when the node enters the scene tree for the first time.
func enter():
	anim_tree.set("parameters/Transition/transition_request", "walk")
	print("running!!!!!")
	pass # Replace with function body.

func exit():
	pass # Replace with function body.

func update(_delta):
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	nixie.SPEED = run_speed

	if Input.is_action_just_released("run"):
		Transitioned.emit(self, "nixiewalk")
