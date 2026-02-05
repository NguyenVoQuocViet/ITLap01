extends CharacterBody2D

@export var speed: float = 180.0
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var interact_area = $InteractionArea 
@onready var footstep_sound = $FootstepSound
var last_direction = "down"

var keyboard_scene = preload("res://prefabs/KeyboardA.tscn")

func _input(event):
	# Kiểm tra nút chuột trái (action "attack")
	if event.is_action_pressed("attack"):
		if GameManager.current_day == 3 and GameManager.washed_face:
			throw_keyboard()
		else:
			# (Tùy chọn) In ra thông báo để bạn kiểm tra lỗi trên máy Victus
			print("Chưa đến lúc sử dụng vũ khí!")

func throw_keyboard():
	var kb = keyboard_scene.instantiate()
	kb.position = global_position
	
	var target_pos = get_global_mouse_position()
	kb.direction = global_position.direction_to(target_pos)
	
	get_tree().current_scene.add_child(kb)

func _physics_process(_delta):
	if GameManager.is_interacting:
		velocity = Vector2.ZERO
		return
		
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
		update_animation("walk", direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		update_animation("idle", Vector2.ZERO)

	move_and_slide()

	# 2. Thêm lại lệnh kiểm tra phím E tại đây
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
		
	if velocity.length() > 0: # Nếu nhân vật đang di chuyển
		if not footstep_sound.playing: # Nếu âm thanh chưa phát
			# Thay đổi cao độ ngẫu nhiên để tiếng bước chân tự nhiên hơn
			footstep_sound.pitch_scale = randf_range(0.8, 1.2)
			footstep_sound.play()
	else:
		footstep_sound.stop() # Dừng âm thanh khi đứng yên

# 3. Thêm hàm xử lý tương tác
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
