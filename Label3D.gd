extends Label3D

var camera

func _ready():
	text = "Hello, World!"
	camera = $Camera  # Replace with the actual path to your Camera node

func _process(delta):
	if camera != null:
		var camera_transform = camera.global_transform
		var look_at_rotation = camera_transform.origin - global_transform.origin
		look_at_rotation.y = 0
		global_transform.basis = Basis().looking_at(look_at_rotation.normalized(), Vector3(0, 1, 0))
