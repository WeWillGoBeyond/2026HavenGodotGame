extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."
@onready var trial_line: Line2D = $AnimatedSprite2D/trial_line
@onready var timer: Timer = $Timer

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

func _on_timer_timeout() -> void:
	stop_rewind()

func rewind_computation():
	player.position = rewind_data["position"].pop_back()
	player.rotation = rewind_data["rotation"].pop_back()
	
func stop_rewind():
	$CollisionShape2D.disabled = false
	rewinding = false
	trial_line.modulate.a = .5

func start_rewind():
	rewinding = true
	$CollisionShape2D.disabled = false
	trial_line.modulate.a = .8
	timer.start()
	
	

const SPEED = 200.0
const JUMP_VELOCITY = -300.0


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("rewind") and not rewinding:
		start_rewind()
		Engine.time_scale
		
	if rewind_data["position"].size() == 0:
		stop_rewind()
	
	if Input.is_action_just_pressed("Unrewind"):
		stop_rewind()

	
	if rewinding:
		rewind_computation()
	else:
		if rewind_data["position"].size() >= 300:
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
	if rewinding:
		return
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			
	global_position = position
	
	if Input.is_action_just_pressed("attack"):
		animated_sprite_2d.play("attack")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("right", "left")
	if rewinding:
		animated_sprite_2d.play("Role")
	elif direction == 0:
		animated_sprite_2d.play("idle_Right")
	else:
		animated_sprite_2d.play("walk_Right")
	if rewinding:
		return
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
