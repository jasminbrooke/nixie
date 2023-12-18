extends RigidBody3D

enum CharacterState { IDLE, WALKING, SCARED, NESTED, CARRIED }

var currentState: CharacterState = CharacterState.IDLE

func initialize(start_position: Vector3, _player_position: Vector3):
	# Initialize the RigidBody3D here
	position = start_position
	linear_velocity = Vector3(0, 0, 2)
	# Add any other initialization code as needed

func enter_state(new_state: CharacterState):
	# Handle entering a new state, perform setup, animations, or other state-specific actions
	currentState = new_state

func exit_state():
	# Handle exiting the current state, perform cleanup or other state-specific actions
	pass

# Example: Transition to the NESTED state when a nesting event occurs
func on_nested():
	if currentState == CharacterState.CARRIED:
		enter_state(CharacterState.NESTED)

# Example: Transition to the CARRIED state when picked up by the player
func on_picked_up():
	enter_state(CharacterState.CARRIED)

# Example: Transition to the IDLE state when released by the player
func on_released():
	enter_state(CharacterState.SCARED)

func _physics_process(_delta):
	match currentState:
		CharacterState.IDLE:
			# Implement logic for the "Idle" state
			linear_velocity = Vector3.ZERO
		CharacterState.WALKING:
			linear_velocity = Vector3(0, 0, -5)
		CharacterState.SCARED:
			linear_velocity = Vector3(0, 0, -10)
		CharacterState.NESTED:
			linear_velocity = Vector3.ZERO
		CharacterState.CARRIED:
			linear_velocity = Vector3.ZERO
