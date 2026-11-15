extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."

var velocity2: Vector2 = Vector2.ZERO 
var speed: float = 600.0
var dir: Vector2 = Vector2.ZERO
var accel: float = 10.0
var friction: float = 8.0

var replay_duration: float = 3.0
var rewinding: bool = false
var rewind_values = {
	"position": [],
	"rotation": [],
	"velocity": [],
}
	




const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var array = null


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	#save rewind values
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("right", "left")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	if direction == 0:
		animated_sprite_2d.play("idle_Right")
	else:
		animated_sprite_2d.play("walk_Right")
		
	
	
	move_and_slide()
