extends State
class_name raccoonhunting

@onready var anim_tree = $"../../AnimationTree"
@onready var rac = self.get_parent().get_parent()
@onready var player = get_node("../../../../World/Nixie")  # Use ".." to go up one level and then specify the node name
@onready var prey : CharacterBody3D
@onready var bunnies_group = "mob"
var speed = 3
@onready var agent = $"../../NavigationAgent3D"
@onready var target: Vector3
@export var wander_time : float = 6

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

func enter():
	anim_tree.set("parameters/Transition/transition_request", "sniff")
	
func update(delta: float):
	if wander_time > 0:
		wander_time -=delta
	else:
		update_target_location()

func _ready():
	update_target_location()
	
func update_target_location():
	var closest_bunny = find_closest_bunny()
	if closest_bunny:
		target = closest_bunny.global_transform.origin
		agent.set_target_position(target)
	
func physics_update(_delta):
	var distance_to_player = rac.global_position.distance_to(player.global_position)
	if distance_to_player < 6:
		Transitioned.emit(self, "raccoonfight")
		

	if rac.position.distance_to(target) > 0.2:
		var curLoc = rac.global_transform.origin
		var nextLoc = agent.get_next_path_position()
		var newVel = (nextLoc - curLoc).normalized() * speed
		# Check if there's a valid direction
		if newVel.length_squared() > 0.0001:
			rac.velocity = newVel
			
			# Set rotation based on the direction vector
			rac.rotation.y = atan2(newVel.x, newVel.z)
			
			## Use look_at to make rac face the target
			#rac.look_at(Vector3(-nextLoc.x, rac.global_transform.origin.y, -nextLoc.z), Vector3.UP)

func _on_navigation_agent_3d_target_reached():
	print("REACHED")
