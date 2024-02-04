extends State
class_name nixierun
@onready var nixie = $"../.."
@onready var run_speed = 9
@onready var anim_tree = $"../../AnimationTree"
@onready var snoof = $"../../Armature/Skeleton3D/Nixie/StaticBody3D/snoot/snoof"

# Called when the node enters the scene tree for the first time.
func enter():
	nixie.speed_multiplier = 1.5
	anim_tree.set("parameters/movement/transition_request", "run")
	anim_tree.set("parameters/runblend/blend_amount", 1.5)
	snoof.strength = 0
	print("running!!!!!")
	pass # Replace with function body.

func exit():
	pass # Replace with function body.

func update(_delta):
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	#nixie.SPEED = run_speed

	if Input.is_action_just_released("run"):
		Transitioned.emit(self, "nixiewalk")
