extends Area3D
@onready var player: CharacterBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body is CharacterBody3D:
		player = body
		print(body, "enter")
		player.is_in_water = true
		print(player.is_in_water)

func _on_body_exited(body):
	if body is CharacterBody3D:
		player = body
		print(body,"exxit")
		player.is_in_water = false
