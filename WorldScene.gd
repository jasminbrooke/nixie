extends Node

export var bunnyScenePath: NodePath  # Reference to the Bunny scene (assign it in the Inspector)
export var numBunniesToSpawn: int = 10  # Number of bunnies to spawn

var bunnyContainer: Node  # Reference to the Bunny Container in the scene

func _ready():
	# Find and store a reference to the Bunny Container node
	bunnyContainer = $/BunnyContainer

	# Spawn all the bunnies
	spawnAllBunnies()

func spawnAllBunnies():
	# Check if the Bunny scene node path is available
	if not is_instance_valid(bunnyScenePath):
		return

	for _ in range(numBunniesToSpawn):
		# Instance a new bunny scene
		var newBunny = bunnyScenePath.instance()
		
		# Set the bunny's initial position (you can randomize this as needed)
		newBunny.global_transform.origin = Vector3(rand_range(-10, 10), 0, rand_range(-10, 10))
		
		# Add the bunny to the Bunny Container
		bunnyContainer.add_child(newBunny)
