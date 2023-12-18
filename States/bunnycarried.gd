extends State
class_name bunnycarried

@onready var anim_tree = $"../../bunny_model/AnimationTree"
@onready var player = get_node("../../../../World/Nixie") # Use ".." to go up one level and then specify the node name
@onready var world = get_node("/root/World/")
var velocity = Vector3.ZERO
@onready var bun = self.get_parent().get_parent()
@onready var bunny_attachment_point = get_node("/root/World/Nixie/Armature/Skeleton3D/BoneAttachment3D/BunnyAttachmentPoint")

func _on_bunny_put_down():
	if bun.is_near_nest:
		Transitioned.emit(self, "nested")
	else:
		Transitioned.emit(self, "scared")

func enter():
	if not player.is_connected("bunny_put_down", _on_bunny_put_down):
		player.bunny_put_down.connect(_on_bunny_put_down)
	bun.get_parent().remove_child(bun)
	bunny_attachment_point.add_child(bun)
	bun.global_transform = bunny_attachment_point.global_transform
	anim_tree.set("parameters/Transition/transition_request", "carried")
	
func exit():
	bun.is_picked_up = false
	bun.get_parent().remove_child(bun)
	world.add_child(bun)
	bun.global_transform = bunny_attachment_point.global_transform
	bun.global_transform.origin.y = 0
	print("carried:", bun)

func physics_update(_delta: float):
	bun.global_transform = bunny_attachment_point.global_transform
	velocity = Vector3.ZERO
			
