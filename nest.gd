extends Area3D

var BunniesInNest = 0
const MAX_BUNNIES_IN_NEST = 6
@onready var fireworks = $Fireworks
@onready var bunniesinnest = $bunniesinnest

func _on_body_entered(body):
	if body.is_in_group("mob"):
		var bun = body
		print("entered")
		fireworks.emitting = true
		print("Detected body:", body, body.get_instance_id())  # Assuming bunnies have names assigned
		BunniesInNest += 1
		bun.is_near_nest = true
		print(BunniesInNest)
		if (MAX_BUNNIES_IN_NEST - BunniesInNest) == 1:
			bunniesinnest.text = str(MAX_BUNNIES_IN_NEST - BunniesInNest) + " bunny is missing from the nest!"
		else:
			bunniesinnest.text = str(MAX_BUNNIES_IN_NEST - BunniesInNest) + " bunnies are missing from the nest!"
		if BunniesInNest >= MAX_BUNNIES_IN_NEST:
			print("Yay!")
			fireworks.amount = 100

func _on_body_exited(body):
	if body.is_in_group("mob"):
		var bun = body
		bun.is_near_nest = false
		print("exited")
		print(BunniesInNest)
		BunniesInNest = max(0, BunniesInNest - 1)
