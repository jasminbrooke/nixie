extends State
class_name teststate

var ROTATION_THRESHOLD = 1
var ROTATION_INTERPOLATION_SPEED = 0.2
@onready var anim_tree = $"../../AnimationTree"
@onready var rac = self.get_parent().get_parent()
@onready var player = get_node("../../../../World/Nixie")  # Use ".." to go up one level and then specify the node name
@onready var prey : CharacterBody3D
@onready var bunnies_group = "mob"
var speed = 1
@onready var agent = $"../../NavigationAgent3D"
@onready var target: Vector3
@export var wander_time : float = 6
var initialY: float  # Variable to store the initial y-coordinate

	
func update(delta: float):
	if wander_time > 0:
		wander_time -=delta
	else:
		update_target_location()

func _ready():
	initialY = rac.global_transform.origin.y
	update_target_location()

func find_closest_bunny():
	var closest_distance = 50
	var closest_bunny = null
	
	for mob in get_tree().get_nodes_in_group("mob"):
		if !mob.is_nested:
			var distance = mob.global_transform.origin.distance_to(rac.global_transform.origin)
			if distance < closest_distance:
				closest_distance = distance
				closest_bunny = mob
	return closest_bunny
	
func update_target_location():
	var closest_bunny = find_closest_bunny()
	if closest_bunny:
		target = closest_bunny.global_transform.origin
		
		agent.set_target_position(target)
	
func physics_update(_delta):
	if rac.position.distance_to(target) > 0.2:
		var curLoc = rac.global_transform.origin
		var nextLoc = agent.get_next_path_position()
		var newVel = (nextLoc - curLoc).normalized() * speed
		
		 # Check if there's a valid direction
		if newVel.length_squared() > 0.0001:
		# Apply 180-degree rotation to face away from the target
			var look_at_direction = -newVel
			rac.look_at(curLoc + look_at_direction, Vector3(0, 1, 0))
			rac.rotation.x = 0
			rac.rotation.z = 0
		# Keep raccoon at the initial y-coordinate
		rac.global_transform.origin.y = initialY
		
		target.y = rac.position.y
		rac.velocity = newVel
		rac.move_and_slide()
	
func _on_navigation_agent_3d_target_reached():
	print("REACHED")
