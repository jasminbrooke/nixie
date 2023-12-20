extends State
class_name nixiewalk
@onready var nixie = $"../.."
var SPEED = 6
@onready var anim_tree = $"../../AnimationTree"

# Called when the node enters the scene tree for the first time.

func enter():
	anim_tree.set("parameters/Transition/transition_request", "walk")

func exit():
	pass # Replace with function body.

func update(_delta):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	nixie.SPEED = SPEED
	if Input.is_action_pressed("sneak"):
		Transitioned.emit(self, "nixiesneak")

	if Input.is_action_pressed("run"):
		Transitioned.emit(self, "nixierun")
