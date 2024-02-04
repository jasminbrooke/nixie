extends State
class_name raccoonfight

var ROTATION_THRESHOLD = 1
var ROTATION_INTERPOLATION_SPEED = 0.2
var FIGHT_DISTANCE = 6.0
var FIGHT_SPEED = 8.0
@onready var anim_tree = $"../../AnimationTree"
@onready var rac = self.get_parent().get_parent()
@onready var player = get_node("../../../../World/Nixie")
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 50
var desired_distance = 10
var speed : float = 10.0
@onready var agent = $"../../NavigationAgent3D"
@onready var target: Vector3
@onready var scare_level: float = 0
@onready var RacPoint = get_node("../../../../World/Nixie/Armature/Skeleton3D/RaccoonBone/RaccoonAttachmentPoint")
var acceptable_distance = 3
var raccoon_speed = 5

func _on_bark():
	print("AHHH!!")
	if scare_level < 10:
		scare_level += 1
	print(scare_level)
	
func _on_navigation_agent_3d_target_reached():
	print("make it FIGHT")

func enter():
	scare_level = 0
	anim_tree.set("parameters/Transition/transition_request", "run")
	if not player.bark.is_connected(_on_bark):
		player.bark.connect(_on_bark)
		
func physics_update(delta: float):
	if scare_level > 9:
		Transitioned.emit(self, "raccoonscared")
	rac.look_at(player.global_position, Vector3.UP)
	var distance_to_target = rac.global_position.distance_to(RacPoint.global_position)
	rac.rotate_y(deg_to_rad(180))
	if distance_to_target > acceptable_distance:
		var target_direction = RacPoint.global_position - rac.global_position
		var direction = target_direction.normalized()
		rac.velocity = direction * raccoon_speed

		if direction.length_squared() > 0.001:
	# Calculate the target position
			var target_position = RacPoint.global_position - direction * desired_distance
	# Gradually move the raccoon towards the target position
			rac.global_position = rac.global_position.lerp(target_position, delta * raccoon_speed)
	
	else:
		# If outside the acceptable distance, rotate freely around RacPoint
		var rotate_axis = Vector3.UP
		rac.rotate_y(deg_to_rad(180))
#
	#agent.set_target_position(target)
	#var target_direction = RacPoint.global_position - rac.global_position
	#var direction = target_direction.normalized()
	#rac.velocity = direction * speed
	#
	#if direction.length_squared() > 0.001:
		#rac.look_at(player.global_position, Vector3.UP)
		   ## Apply a 180-degree rotation around the Y-axis
	#rac.rotate_y(deg_to_rad(180))
