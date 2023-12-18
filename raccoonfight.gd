extends State
class_name raccoonfight

var ROTATION_THRESHOLD = 1
var ROTATION_INTERPOLATION_SPEED = 0.2
var FIGHT_DISTANCE = 6.0  # Adjust this distance as needed
var FIGHT_SPEED = 8.0  # Adjust the speed at which bunnies run away
@onready var anim_tree = $"../../AnimationTree"
@onready var rac = self.get_parent().get_parent()
@onready var player = get_node("../../../../World/Nixie")  # Use ".." to go up one level and then specify the node name
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 50
var desired_distance = 10
var speed : float = 10.0  # Adjust the default speed as needed
@onready var agent = $"../../NavigationAgent3D"
@onready var target: Vector3
@onready var scare_level: float = 0
@onready var RacPoint = get_node("../../../../World/Nixie/Armature/Skeleton3D/RaccoonBone/RaccoonAttachmentPoint")

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
		
func physics_update(_delta: float):
	if scare_level > 9:
		Transitioned.emit(self, "raccoonscared")

	agent.set_target_position(target)
	var target_direction = RacPoint.global_position - rac.global_position
	var direction = target_direction.normalized()
	rac.velocity = direction * speed
	
	if direction.length_squared() > 0.001:
		rac.look_at(player.global_position, Vector3.UP)
		   # Apply a 180-degree rotation around the Y-axis
	rac.rotate_y(deg_to_rad(180))
