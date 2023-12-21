extends State
class_name raccoonidle

@onready var anim_tree = $"../../AnimationTree"
@export var speed = 1
@onready var player = get_node("../../../../World/Nixie")
@onready var move_direction = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
@export var wander_time : float
@export var velocity = Vector3.ZERO
@onready var rac = self.get_parent().get_parent()
var rotationThreshold = 0.1

func randomize_wander():
	var distance_to_player = rac.global_position.distance_to(player.global_position)
	move_direction = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
	
	wander_time = randi_range(4, 6)
	if distance_to_player > 6:
		Transitioned.emit(self, "raccoonhunting")

func enter():
	anim_tree.set("parameters/Transition/transition_request", "sniff")
	randomize_wander()

func update(delta: float):
	if wander_time > 0:
		wander_time -=delta
	else:
		randomize_wander()
		
func physics_update(_delta: float):
	var distance_to_player = rac.global_position.distance_to(player.global_position)
	if distance_to_player < 6:
		Transitioned.emit(self, "raccoonfight")
