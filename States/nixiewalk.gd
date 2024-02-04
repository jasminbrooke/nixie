extends State
class_name nixiewalk
@onready var nixie = $"../.."
var SPEED = 6
@onready var anim_tree = $"../../AnimationTree"
@onready var snoof = $"../../Armature/Skeleton3D/Nixie/StaticBody3D/snoot/snoof"

# Called when the node enters the scene tree for the first time.

func enter():
	nixie.speed_multiplier = 1
	snoof.strength = 0
	anim_tree.set("parameters/movement/transition_request", "walk")
	
func exit():
	pass # Replace with function body.

func update(_delta):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func physics_update(_delta):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	if not input_dir:
		anim_tree.set("parameters/movement/transition_request", "idle")
	
	#nixie.SPEED = SPEED
		
	#if nixie.velocity.is_zero_approx():
		#anim_tree.set("parameters/Transition/transition_request", "still")

	if Input.is_action_pressed("sneak"):
		Transitioned.emit(self, "nixiesneak")

	if Input.is_action_pressed("run"):
		Transitioned.emit(self, "nixierun")
	
