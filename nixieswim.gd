extends State
class_name nixieswim
@onready var nixie = $"../.."
@onready var anim_tree = $"../../AnimationTree"
@onready var snoof = $"../../Armature/Skeleton3D/Nixie/StaticBody3D/snoot/snoof"
@onready var splash = $"../../Armature/Skeleton3D/Nixie/splash"
@onready var swimspeed = 4
@onready var surface = $"../../../background/rivers/lakeplane"
const JUMP_VELOCITY = 5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var t = 0.0
@onready var surface_offset = 1.1 #higher number is lower height
var river_force = 2


func enter():
	nixie.speed_multiplier = .5
	splash.emitting = true
	print("swimming!!!!")
	snoof.strength = 0
	anim_tree.set("parameters/groundorwater/transition_request", "in_water")
	anim_tree.set("parameters/swiming/blend_amount", 1)
	
func exit():
	splash.emitting = false
	anim_tree.set("parameters/groundorwater/transition_request", "on_ground")

func physics_update(delta):
	nixie.velocity.y -= gravity * delta
	
	# Apply a constant force in the x direction each frame
	nixie.velocity.x = river_force * delta
	
	var surface_y = surface.global_position.y - surface_offset
	nixie.global_position.y = max(nixie.global_position.y, surface_y)
	splash.global_position.y = surface_y + 1

	if Input.is_action_just_pressed("jump"):
		nixie.velocity.y = JUMP_VELOCITY
		nixie.global_position.y = surface_y
	
	if not nixie.is_in_water:
		Transitioned.emit(self, "nixiewalk")
	#nixie.SPEED = swimspeed
