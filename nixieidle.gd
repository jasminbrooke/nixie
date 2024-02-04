extends State
class_name nixieidle
@onready var nixie = $"../.."
@onready var anim_tree = $"../../AnimationTree"
@onready var snoof = $"../../Armature/Skeleton3D/Nixie/StaticBody3D/snoot/snoof"

# Called when the node enters the scene tree for the first time.

func enter():
	snoof.strength = 0
	anim_tree.set("parameters/movement/transition_request", "idle")
	
func exit():
	pass # Replace with function body.

func update(_delta):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	pass
	if Input.is_action_pressed("sneak"):
		Transitioned.emit(self, "nixiesneak")

	if Input.is_action_pressed("run"):
		Transitioned.emit(self, "nixierun")
		
	#if nixie.velocity.is_zero_approx():
		#anim_tree.set("parameters/Transition/transition_request", "still")
