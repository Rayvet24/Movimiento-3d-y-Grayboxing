extends CharacterBody3D

const SPEED = 5.0
var Alternate: bool
const HIGH_JUMP_VELOCITY = 13
const LOW_JUMP_VELOCITY = HIGH_JUMP_VELOCITY/1.7
var Double_Jump: bool

func _ready() -> void:
	Alternate = false

func _physics_process(delta: float) -> void:
	#Grevedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	#Al tocar botón se cambia alternan las fuerzas de salto
	if Input.is_action_just_pressed("Alternate Jump"):
		Alternate = !Alternate
	
	#Resetear doble salto
	if is_on_floor():
		Double_Jump = true
	
	#Salto normal
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		if Alternate == false:
			velocity.y = HIGH_JUMP_VELOCITY
		else:
			velocity.y = LOW_JUMP_VELOCITY
	#Doble salto
	if Input.is_action_just_pressed("Jump") and not is_on_floor() and Double_Jump == true:
		if Alternate == false:
			velocity.y = LOW_JUMP_VELOCITY
		else:
			velocity.y = HIGH_JUMP_VELOCITY
		Double_Jump = false
	
	#Movimiento básico
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	#Rotar
	if Input.is_action_pressed("Rotate cam left"):
		rotate(Vector3.UP, 1 * delta)
	if Input.is_action_pressed("Rotate cam right"):
		rotate(Vector3.UP, -1 * delta)
	
	move_and_slide()
