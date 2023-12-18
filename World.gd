extends Node

@onready var nest = $Nest
@export var mob_scene: PackedScene
@onready var screeninfo = $screeninfo

func _ready():
	if mob_scene:
		spawn_mobs(6)
		
func spawn_mobs(count):
	for m in range(count):
		# Create a new instance of the Mob scene.
		var mob = mob_scene.instantiate()

		# Assign a unique name or id to each mob.
		var mob_name = "Mob_" + str(m)
		mob.name = mob_name
		# Choose a randomw location on the SpawnPath.
		# We store the reference to the SpawnLocation node.
		var mob_spawn_location = get_node("SpawnPath/SpawnLocation")

		# Give it a random offset.
		mob_spawn_location.progress_ratio = randf()
		var player_position = $Nixie.position
		mob.initialize(mob_spawn_location.position, player_position)
		# Spawn the mob by adding it to the Main scene.
		add_child(mob)
