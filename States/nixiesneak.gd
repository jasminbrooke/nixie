extends State
class_name nixiesneak
@onready var nixie = $"../.."
@onready var sneak_speed = 2


# Called when the node enters the scene tree for the first time.
func enter():
	print("sneaking!!!!!")
	pass # Replace with function body.

func exit():
	pass # Replace with function body.

func update(_delta):
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	nixie.SPEED = sneak_speed
	
	if Input.is_action_just_released("sneak"):
		Transitioned.emit(self, "nixiewalk")
