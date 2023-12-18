var player_position = global_transform.origin
		var closest_bunny = find_closest_bunny()

		if closest_bunny:
			var distance_to_bunny = player_position.distance_to(closest_bunny.global_transform.origin)
			print("Distance to closest bunny:", distance_to_bunny)
			if distance_to_bunny <= BUNNY_INTERACTION_DISTANCE:
				print("A bunny is in range.")
			else:
				print("A bunny is NOT in range.")
		else:
			print("No bunny found.")
			
func find_closest_bunny():
	var closest_bunny = null
	var closest_distance = float("inf")
	var player_position = global_transform.origin

	# Get all nodes in the "mob" group
	var bunny_group = get_tree().get_nodes_in_group("mob")
	if bunny_group.size() == 0:
		print("No bunnies found in the 'mob' group.")
	else:
		print(bunny_group.size(), "bunnies found.")

	for mob in bunny_group:
		var mob_position = mob.global_transform.origin
		var distance = player_position.distance_to(mob_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_bunny = mob
			
	return closest_bunny
	
	
	
	extends RigidBody3D

# Emitted when the player jumped on the mob.
signal squashed

func squash():
	squashed.emit()
	queue_free()

@export var min_speed = 1
@export var max_speed = 2
@onready var anim_tree = $AnimationTree

func _physics_process(_delta):
	move_and_slide()
	
	var _speed = velocity.length()
	
# This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

