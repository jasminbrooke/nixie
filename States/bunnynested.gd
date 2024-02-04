extends State
class_name bunnynested

@onready var anim_tree = $"../../bunny_model/AnimationTree"
@onready var player = get_node("../../../../World/Nixie")
@onready var world = get_node("/root/World/")
@onready var nest = get_node("../../../../World/Nest")
var velocity = Vector3.ZERO
@onready var bun = self.get_parent().get_parent()
@onready var bunny_attachment_point = get_node("/root/World/Nixie/Armature/Skeleton3D/BoneAttachment3D/BunnyAttachmentPoint")
@onready var scent = %scent

func enter():
	anim_tree.set("parameters/Transition/transition_request", "up")
	bun.global_transform.origin.y = 0
	scent.emitting = false
	velocity = Vector3.ZERO
	bun.is_picked_up = false
	
func exit():
	pass

func physics_update(_delta: float):
	var direction_to_player = player.global_transform.origin - bun.global_transform.origin
	direction_to_player.y = 0
	# Make the bunny look towards the player
	bun.look_at(bun.global_transform.origin + direction_to_player, Vector3.UP)
##
