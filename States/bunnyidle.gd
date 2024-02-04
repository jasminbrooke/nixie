extends State
class_name bunnyidle

@onready var anim_tree = $"../../bunny_model/AnimationTree"
@onready var bun = self.get_parent().get_parent()
@export var speed = 1
@onready var player = get_node("../../../../World/Nixie")  # Use ".." to go up one level and then specify the node name
@export var move_direction = Vector3(randi(), 0, randf()).normalized()  # Random 
@export var wander_time : float
@export var velocity = Vector3.ZERO
@onready var box = get_node("../../../../World/Nixie/Armature/Skeleton3D/Nixie/ShapeCast3D") 
var ROTATION_THRESHOLD = 1
var ROTATION_INTERPOLATION_SPEED = 0.2
@onready var scent = %scent
var damping_factor = 0.5  # Moved to class level
var SIBLING_DISTANCE = 5

func _on_bunny_picked_up():
	if bun.is_picked_up == true:
		Transitioned.emit(self, "carried")

func randomize_wander():
	move_direction = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
	wander_time = randi_range(15, 25)
	get_closest_bunny()

func enter():
	if not player.is_connected("bunny_picked_up", _on_bunny_picked_up):
		player.bunny_picked_up.connect(_on_bunny_picked_up)
	anim_tree.set("parameters/Transition/transition_request", "hop")
	randomize_wander()
	scent.emitting = true
	
func update(delta: float):
	if wander_time > 0:
		wander_time -=delta
	else:
		randomize_wander()
		avoid_siblings()
		
func physics_update(delta: float):
	bun.position.y = 0
	bun.look_at(bun.global_transform.origin + move_direction, Vector3.UP)
	bun.velocity = move_direction * speed
	bun.move_and_slide()
	var nixiestate = player.statemachine.current_state
	var distance_to_box = bun.global_position.distance_to(box.global_position)
	var distance_to_player = bun.global_position.distance_to(player.global_position)
	if distance_to_player < 6 and not nixiestate is nixiesneak:
		Transitioned.emit(self, "scared")

func get_closest_bunny() -> CharacterBody3D:
	var closest_bunny: CharacterBody3D = null
	var min_distance: float = SIBLING_DISTANCE  # Set to a large initial value
	# Iterate through all bunnies in the scene
	for sibling in get_tree().get_nodes_in_group("mob"):
		var distance = bun.global_transform.origin.distance_to(sibling.global_transform.origin)
		if distance < min_distance:
			min_distance = distance
			closest_bunny = sibling
	return closest_bunny
	
func avoid_siblings():
	var closest_sibling: CharacterBody3D = get_closest_bunny()
	if closest_sibling != null:
		var to_sibling = closest_sibling.global_transform.origin - bun.global_transform.origin
		to_sibling.y = 0  # Ignore height difference
		to_sibling = to_sibling.normalized()

		# Adjust move_direction to move away from the closest sibling
		move_direction -= to_sibling * damping_factor
		move_direction = move_direction.normalized()
