extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# --- Nuevas variables para el doble salto ---
const MAX_JUMPS = 2 # Define la cantidad máxima de saltos (1 = normal, 2 = doble, etc.)
var jump_count = 0  # Contador para los saltos realizados

@onready var sprite_2d = $Sprite2D

# Obtener la gravedad de la configuración del proyecto.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Añadir gravedad.
	if not is_on_floor():
		velocity.y += gravity * delta
		# Mantenemos la animación de salto si ya está en el aire.
		if sprite_2d.animation != "Jump":
			sprite_2d.animation = "Jump"
	else:
		# --- Lógica nueva: reiniciar contador en el suelo ---
		jump_count = 0

	# --- Lógica de salto modificada ---
	# Ahora revisa si el contador es menor que el máximo permitido.
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1 # Incrementamos el contador con cada salto

	# Obtener la dirección del input y manejar el movimiento.
	var direction = Input.get_axis("left", "right")

	# Cambiar la animación a "Run" o "Idle" y mover el personaje.
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor(): # Solo cambia a "Run" si está en el suelo
			sprite_2d.animation = "Run"
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
		if is_on_floor(): # Solo cambia a "Idle" si está en el suelo
			sprite_2d.animation = "Idle"

	# Voltear el sprite según la dirección.
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
	move_and_slide()
