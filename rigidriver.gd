extends RigidBody3D

@onready var particleNode = $"../water"  # Replace with the correct path to your particle node
var particleDistance = 5  # Distance between particles
var spawnDelay = 0.5  # Delay between spawning particles in seconds
var timePassed = 0.0
var xOffset = 0.0  # Initial offset for particles

func _process(delta):
	timePassed += delta

	if timePassed > spawnDelay:
		spawn_particles()
		timePassed = 0.0

func spawn_particles():
	for i in range(10):  # Adjust the number of particles to spawn
		var particle = particleNode.duplicate()
		add_child(particle)  # Add the duplicated particle to the scene
		particle.global_transform.origin.x = xOffset + i * particleDistance  # Set the initial position

	xOffset += 10.0  # Adjust this value based on the separation you desire between groups of particles
