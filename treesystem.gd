extends MeshInstance3D
@onready var system: Node = self  # Replace with the actual path to your child node container

# Called when the node enters the scene tree for the first time.
func _ready():
	print(system)
	for i in range(system.get_child_count()):
		var child = system.get_child(i)
		var collision_shape = CollisionShape3D.new()
		var cyl_shape = CylinderShape3D.new()
		collision_shape.shape = cyl_shape

		collision_shape.transform = child.transform
		collision_shape.transform.origin.y = 0
		add_child(collision_shape)
