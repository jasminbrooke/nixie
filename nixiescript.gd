extends CharacterBody3D

signal bark
signal bunny_picked_up
signal bunny_put_down

@onready var statemachine = $StateMachine
@onready var bunny_attachment_point = $Armature/Skeleton3D/BoneAttachment3D/BunnyAttachmentPoint
@onready var armature = $Armature
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var anim_tree = $AnimationTree
@onready var nest = get_node("../Nest")  # Load the scene resource
const LERP_VAL = .15
const BUNNY_INTERACTION_DISTANCE = 2
const JUMP_VELOCITY = 5
var default_layer = 0
@onready var carrying_bunny: CharacterBody3D = null
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var shapecast = %ShapeCast3D
@onready var label = $Label3D
var bark_count = 0
@export var SPEED = 6
var interaction_processed = false

func _ready():
	if label:
		label.text = str(statemachine.current_state)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
func _physics_process(_delta):
	label.text = str(statemachine.current_state)
	if Input.is_action_just_pressed("bark"):
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
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		anim_tree.set("parameters/Transition/transition_request", "walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim_tree.set("parameters/Transition/transition_request", "still")
	move_and_slide()
	
# Check if the player is attempting to pick up the bunny
	if Input.is_action_just_pressed("interact"):
		print("Interact pressed")
		anim_tree.set("parameters/Transition/transition_request", "pickup")
		anim_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		var target_bunny: CharacterBody3D = null
		if carrying_bunny == null and shapecast.is_colliding():
			target_bunny = shapecast.get_collider(0)
		toggle_bunny_state(target_bunny)
			
func toggle_bunny_state(target_bunny):
	if carrying_bunny == null:
		if target_bunny != null:  # Check if there is a target bunny
			pick_up_bunny(target_bunny)
	else:
		put_down_bunny()
				
func pick_up_bunny(target_bunny): 
	if carrying_bunny == null:
		carrying_bunny = target_bunny
		self.emit_signal("bunny_picked_up")
		
func put_down_bunny():
	self.emit_signal("bunny_put_down")
	carrying_bunny = null
