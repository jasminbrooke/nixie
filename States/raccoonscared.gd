extends State
class_name raccoonscared

var ROTATION_THRESHOLD = 1
var ROTATION_INTERPOLATION_SPEED = 0.2
var SCARE_DISTANCE = 6.0
var SCARE_SPEED = 8.0
@onready var anim_tree = $"../../AnimationTree"
@onready var rac = self.get_parent().get_parent()
@onready var player = get_node("../../../../World/Nixie")

func enter():
	anim_tree.set("parameters/Transition/transition_request", "run")

func physics_update(_delta: float):
	var distance_to_player = rac.global_position.distance_to(player.global_position)
	var direction = player.global_position - rac.global_position
	if distance_to_player > 20:
		Transitioned.emit(self, "raccoonidle")
	else:
		handle_scared_behavior(direction, _delta)
		
func handle_scared_behavior(direction: Vector3, delta: float):
	if rac.is_on_wall():
		Transitioned.emit(self, "raccoonidle")
	var direction_away = -direction.normalized()
	direction_away.y = 0
	var desired_rotation = direction_away.angle_to(Vector3.UP)
	desired_rotation += PI
	var rotation_diff = abs(rac.rotation.y - desired_rotation)

	if rotation_diff > ROTATION_THRESHOLD:
		var rounded_rotation = round(rac.rotation.y / ROTATION_THRESHOLD) * ROTATION_THRESHOLD
		rac.rotation.y = lerp(rac.rotation.y, rounded_rotation, ROTATION_INTERPOLATION_SPEED)

	rac.velocity = direction_away * SCARE_SPEED - Vector3(0, ProjectSettings.get_setting("physics/3d/default_gravity") * delta, 0)
	rac.look_at(rac.global_transform.origin + -direction_away, Vector3.UP)
