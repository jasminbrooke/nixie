extends State
class_name bunnyscared

@onready var bun = self.get_parent().get_parent()
@export var speed = 5
@onready var anim_tree = $"../../bunny_model/AnimationTree"
@onready var player = get_node("../../../../World/Nixie")
@onready var rac = get_node("../../../../World/raccoon")
var ROTATION_THRESHOLD = 1
var ROTATION_INTERPOLATION_SPEED = 0.2
var SCARE_DISTANCE = 6.0 
var SCARE_SPEED = 8.0
@onready var scent = %scent
@onready var scaredscent = %scared

func _on_bunny_picked_up():
	if bun.is_picked_up == true:
		Transitioned.emit(self, "carried")
	
func exit():
	scent.emitting = true
	scaredscent.emitting = false
	
func enter():
	if not player.is_connected("bunny_picked_up", _on_bunny_picked_up):
		player.bunny_picked_up.connect(_on_bunny_picked_up)
	scent.emitting = false
	scaredscent.emitting = true
	if anim_tree:
		anim_tree.active = true  # Activate the animation tree
		anim_tree.set("parameters/Transition/transition_request", "run")

func physics_update(_delta: float):
	var distance_to_player = bun.global_position.distance_to(player.global_position)
	var direction = player.global_position - bun.global_position
	if distance_to_player > 10:
		Transitioned.emit(self, "idle")
	else:
		handle_scared_behavior(direction, _delta)
		
			
func handle_scared_behavior(direction: Vector3, delta: float):
	scent.emitting = false
	var direction_away = -direction.normalized()
	direction_away.y = 0
	var desired_rotation = direction_away.angle_to(Vector3.FORWARD)
	desired_rotation += PI
	var rotation_diff = abs(bun.rotation.y - desired_rotation)

	if rotation_diff > ROTATION_THRESHOLD:
		var rounded_rotation = round(bun.rotation.y / ROTATION_THRESHOLD) * ROTATION_THRESHOLD
		bun.rotation.y = lerp(bun.rotation.y, rounded_rotation, ROTATION_INTERPOLATION_SPEED)
	bun.look_at(bun.global_transform.origin + direction_away, Vector3.UP)

	bun.velocity = direction_away * SCARE_SPEED - Vector3(0, ProjectSettings.get_setting("physics/3d/default_gravity") * delta, 0)
	bun.move_and_slide()
