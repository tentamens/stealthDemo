class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var MOUSE_SENSITIVITY = 1
@onready var camera = $Neck/Camera3D
@onready var neck = $Neck


@export var slidingMultiplier:float = 1.5
@export var slidingDelay: float = 0.75
@export var slideFriction: float = 0.1

var trueSlide = 1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var newTimer = Timer.new()
	add_child(newTimer)
	newTimer.wait_time = slidingDelay
	newTimer.name = "slidingDelay"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	


	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if trueSlide > 1:
		trueSlide -= slideFriction
		print("hello world")
		velocity.x *= trueSlide
		velocity.z *= trueSlide
	
	if Input.is_action_just_pressed("Slide") and is_on_floor() and $slidingDelay.is_stopped:
		var newVel = slide(velocity)
		print(velocity.x)
		velocity.x = newVel[0]
		print(velocity.x)
		velocity.z = newVel[1]


	
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		Crotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
		Crotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))

func Crotate_x(angle):
	camera.rotation_degrees.x += angle/-1
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func Crotate_y(angle):
	neck.rotation_degrees.y += angle



func slide(vel):
	get_node("slidingDelay").start()
	trueSlide = slidingMultiplier
	return [vel.x * slidingMultiplier, vel.z * slidingMultiplier, ]
