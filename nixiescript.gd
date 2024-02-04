extends CharacterBody3D

signal bark
signal bunny_picked_up
signal bunny_put_down

@onready var nixieswimstate = $StateMachine/nixieswim
@onready var statemachine = $StateMachine
@onready var bunny_attachment_point = $Armature/Skeleton3D/BoneAttachment3D/BunnyAttachmentPoint
@onready var armature = $Armature
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var anim_tree = $AnimationTree
@onready var nest = get_node("../Nest")  # Load the scene resource
@onready var carrying_bunny: CharacterBody3D = null
@onready var shapecast = %ShapeCast3D
@onready var label = $Label3D
@export var SPEED = 6
@export var is_in_water: bool = false
@onready var splash = $Armature/Skeleton3D/Nixie/splash
@onready var current_anim = null
@onready var speed_multiplier = 0
const LERP_VAL = .15
const BUNNY_INTERACTION_DISTANCE = 2
const JUMP_VELOCITY = 5
var default_layer = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bark_count = 0
var target_bunny: CharacterBody3D = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	anim_tree.set("parameters/groundorwater/transition_request", "on_ground")

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_input(event)
	elif event is InputEventJoypadMotion:
		handle_controller_input(event)

func handle_mouse_input(event):
	spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
	spring_arm.rotate_x(-event.relative.y * 0.005)
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func handle_controller_input(event):
	var dead_zone = 0.5
	var sensitivity = 0.1
	
# Check if the input is on a specific axis
	if event.get_axis() == 2:
		# Rotate around the y-axis (left and right)
		spring_arm_pivot.rotate_y(-event.get_axis_value() * sensitivity)
	elif event.get_axis() == 3:
		# Rotate around the x-axis (up and down)
		spring_arm.rotate_x(-event.get_axis_value() * sensitivity)
		# Clamp the x-rotation to a specific range
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
	
func _physics_process(_delta):
	if label:
		label.text = str(statemachine.current_state.get_name())
	
	if is_in_water == true and not statemachine.current_state.get_name() == "nixieswim":
		statemachine.current_state.Transitioned.emit(statemachine.current_state, "nixieswim")
	
	if Input.is_action_just_pressed("bark"):
		anim_tree.set("parameters/OneShotConditions/transition_request", "bark")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

		self.emit_signal("bark")
		print("woof!")
		if bark_count < 10:
			label.text += "\nwoof!"
			bark_count += 1
		else:
			label.text = ""
			bark_count = 0  # Reset count to 0
		
	if not is_on_floor():
		velocity.y -= gravity * _delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		anim_tree.set("parameters/jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		velocity.y = JUMP_VELOCITY
	elif is_on_floor() and anim_tree.get("parameters/jump/active"):
	# If the player is on the floor and the jump animation is active, stop the jump animation.
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		velocity.x = direction.x * SPEED * speed_multiplier
		velocity.z = direction.z * SPEED * speed_multiplier
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		if not is_in_water:
			statemachine.current_state.Transitioned.emit(statemachine.current_state, "nixiewalk")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if not is_in_water:
			statemachine.current_state.Transitioned.emit(statemachine.current_state, "nixieidle")
	move_and_slide()
	
	#if shapecast.is_colliding():
		#target_bunny = shapecast.get_collider(0)
	#else:
		#target_bunny = null
			
# Check if the player is attempting to pick up the bunny
	if Input.is_action_just_pressed("interact"):
		#target_bunny = shapecast.get_collider(0)
		print("Interact pressed")
		anim_tree.set("parameters/OneShotConditions/transition_request", "pickup")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		#if target_bunny != null:
			#toggle_bunny_state(target_bunny)
			
func toggle_bunny_state(target_bunny):
	target_bunny = shapecast.get_collider(0)
	print("toggle_bunny_called", target_bunny)
	if target_bunny != null: #for attempting animation
		if carrying_bunny == null:
			pick_up_bunny(target_bunny)
		else:
			put_down_bunny()
	print(target_bunny, carrying_bunny)
				
func pick_up_bunny(target_bunny): 
	carrying_bunny = target_bunny
	target_bunny = null
	carrying_bunny.is_picked_up = true
	self.emit_signal("bunny_picked_up")
		
func put_down_bunny():
	carrying_bunny.is_picked_up = false
	self.emit_signal("bunny_put_down")
	carrying_bunny = null
	target_bunny = null
