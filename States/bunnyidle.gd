extends State
class_name bunnyidle

@onready var anim_tree = $"../../bunny_model/AnimationTree"
@onready var bun = self.get_parent().get_parent()
@export var speed = 1
@onready var player = get_node("../../../../World/Nixie")  # Use ".." to go up one level and then specify the node name
@export var move_direction = Vector3(randi(), 0, randf()).normalized()  # Random 
@export var wander_time : float
@export var velocity = Vector3.ZERO
@onready var bunny_cast = $"../../BunnyCast"
@onready var box = get_node("../../../../World/Nixie/Armature/Skeleton3D/Nixie/ShapeCast3D") 
var collision_cooldown : float = 1.0  # Set a cooldown time

func randomize_wander():
	move_direction = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
	wander_time = randi_range(5, 15)

func enter():
	anim_tree.set("parameters/Transition/transition_request", "hop")
	randomize_wander()
	
func update(delta: float):
	if wander_time > 0:
		wander_time -=delta
	else:
		randomize_wander()
		
func physics_update(_delta: float):
	if collision_cooldown > 0:
		collision_cooldown -= _delta
	else:
		if bunny_cast.is_colliding():
			print(bunny_cast.get_collider(0))
			print(bunny_cast.is_colliding())
			# Calculate a new move_direction vector by avoiding the obstacle
			move_direction = move_direction.reflect(bunny_cast.get_collision_normal(0))
			move_direction.y = 0  # Keep the movement in the horizontal plane
			collision_cooldown = 1.0  # Reset the cooldown
	bun.position.y = 0
	bun.look_at(bun.global_transform.origin + move_direction, Vector3.UP)
	bun.velocity = move_direction * speed
	bun.move_and_slide()
	var nixiestate = player.statemachine.current_state
	var distance_to_box = bun.global_position.distance_to(box.global_position)
	var distance_to_player = bun.global_position.distance_to(player.global_position)
	if distance_to_player < 6 and not nixiestate is nixiesneak:
		Transitioned.emit(self, "scared")
	if distance_to_box < 2 and nixiestate is nixiesneak:
		if not player.is_connected("bunny_picked_up", _on_bunny_picked_up):
				player.bunny_picked_up.connect(_on_bunny_picked_up)
		
func _on_bunny_picked_up():
	Transitioned.emit(self, "carried")  # Emit the transition signal for "carried" state
	
