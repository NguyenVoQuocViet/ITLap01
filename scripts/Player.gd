extends CharacterBody2D

@export var speed: float = 180.0
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var interact_area = $InteractionArea 
@onready var footstep_sound = $FootstepSound
var joystick = null
var last_direction = "down"

var keyboard_scene = preload("res://prefabs/KeyBoardA.tscn")

func _ready():
	await get_tree().create_timer(0.1).timeout
	joystick = get_tree().current_scene.find_child("VirtualJoystick", true, false)

	if OS.get_name() in ["Android", "iOS"]:
		$Camera2D.enabled = true
		$Camera2D.make_current()
		$Camera2D.zoom = Vector2(3.0, 3.0)

	GameManager.is_interacting = false

func _input(event):
	pass
	
func throw_keyboard():
	var kb = keyboard_scene.instantiate()
	kb.position = global_position
	
	var target_pos = Vector2.ZERO
	
	if OS.get_name() == "Windows":
		target_pos = get_global_mouse_position()
	else:
		var throw_dir = Vector2.DOWN 
		match last_direction:
			"up": throw_dir = Vector2.UP
			"down": throw_dir = Vector2.DOWN
			"left": throw_dir = Vector2.LEFT
			"right": throw_dir = Vector2.RIGHT
		
		target_pos = global_position + throw_dir * 100
	
	kb.direction = global_position.direction_to(target_pos)
	get_tree().current_scene.add_child(kb)

func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
		return

	if Input.is_action_just_pressed("attack"):
		var current_map = get_tree().current_scene.name
		if "Classroom" in current_map and GameManager.current_day == 3 and GameManager.washed_face:
			throw_keyboard()
		else:
			print("Chưa đến lúc sử dụng vũ khí!")
	
	if not GameManager.is_interacting:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if direction == Vector2.ZERO and joystick and joystick.is_pressed:
			direction = joystick.output
		
	if direction != Vector2.ZERO:
		velocity = direction * speed
		update_animation("walk", direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		update_animation("idle", Vector2.ZERO)
		
	move_and_slide()
		
	if velocity.length() > 0: 
		if not footstep_sound.playing: 
			footstep_sound.pitch_scale = randf_range(0.8, 1.2)
			footstep_sound.play()
	else:
		footstep_sound.stop() 

func execute_interaction():
	# Lấy danh sách các vật thể (Body) nằm trong vùng InteractionArea
	var targets = interact_area.get_overlapping_bodies()
	
	for target in targets:
		# Nếu vật thể đó (như StudyDesk) có hàm interact, thì gọi nó
		if target.has_method("interact"):
			target.interact()
			break # Chỉ tương tác với 1 vật thể gần nhất

func update_animation(state, dir):
	if dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			last_direction = "right" if dir.x > 0 else "left"
		else:
			last_direction = "down" if dir.y > 0 else "up"
	
	var anim_name = state + "_" + last_direction
	anim.play(anim_name)
