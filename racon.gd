extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."

var velocity2: Vector2 = Vector2.ZERO 
var speed: float = 600.0
var dir: Vector2 = Vector2.ZERO
var accel: float = 10.0
var friction: float = 8.0

var replay_duration: float = 3
var rewinding: bool = false
var rewind_data = {
	"position": [],
	"rotation": [],
	"velocity": [],
}

func rewind_computation():
	print("rewinding...")
	player.position = rewind_data["position"].pop_back()
	player.rotation = rewind_data["rotation"].pop_back()
	
func stop_rewind():
	$CollisionShape2D.disabled = false
	rewinding = false

func start_rewind():
	rewinding = true
	$CollisionShape2D.disabled = false

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var array = null


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("rewind") and not rewinding:
		start_rewind()
		
	if rewind_data["position"].size() == 0:
		stop_rewind()
	
	if Input.is_action_just_pressed("Unrewind"):
		print("unrewound")
		stop_rewind()
	
	#save rewind values
	
	
	if rewinding:
		rewind_computation()
	else:
		if rewind_data["position"].size() >= replay_duration * Engine.get_frames_per_second():
			for key in rewind_data.keys():
				rewind_data[key].pop_front()
		rewind_data["position"].append(global_position)
		rewind_data["rotation"].append(rotation)
		rewind_data["velocity"].append(velocity)
	move_and_slide()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	


		
	global_position = position
	

		
	

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



	
	
	


	
