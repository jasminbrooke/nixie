extends State
class_name bunnyidle

@onready var anim_tree = $"../../bunny_model/AnimationTree"
@onready var bun = self.get_parent().get_parent()
@export var speed = 1  # Adjust this value as needed
@onready var player = get_node("../../../../World/Nixie")  # Use ".." to go up one level and then specify the node name
@export var move_direction = Vector3(randi(), 0, randf()).normalized()  # Random 
@export var wander_time : float
@export var velocity = Vector3.ZERO

func randomize_wander():
	move_direction = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
	wander_time = randi_range(4, 6)

func enter():
	anim_tree.set("parameters/Transition/transition_request", "hop")
	randomize_wander()

func update(delta: float):
	if wander_time > 0:
		wander_time -=delta
	else:
		randomize_wander()
		
func physics_update(_delta: float):
	var distance_to_player = bun.global_position.distance_to(player.global_position)
	if distance_to_player < 6:
		Transitioned.emit(self, "scared")
	else:
		bun.look_at(bun.global_transform.origin + move_direction, Vector3.UP)
		bun.velocity = move_direction * speed
		bun.move_and_slide()
		
