extends CharacterBody3D

var current_speed : int = 5
var lerp_speed : float = 10.0
var mouse_sens : float = 0.3

const walking_speed : int = 5
const sprinting_speed : int = 8
const air_speed : int = 2
const sit_speed : int = 5
const jump_velocity : int = 6

@onready var head: Node3D = $Head

var direction = Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x) * -mouse_sens)
		head.rotate_x(deg_to_rad(event.relative.y) * -mouse_sens)
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-80),deg_to_rad(85))

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("SPRINT"):
		current_speed = sprinting_speed
	else:
		current_speed = walking_speed
	
	if not is_on_floor():
		velocity += get_gravity()*2 * delta
	
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir = Input.get_vector("A","D","W","S")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
