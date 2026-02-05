extends CharacterBody2D

@export var speed = 60.0
@export var attack_range = 80.0 # Tầm đánh bao quát
@onready var sprite = $Sprite2D #
@onready var nav_agent = $NavigationAgent2D #
@onready var zombie_sound = $ZombieSound
@onready var idle_timer = $IdleTimer

var target_player: Node2D = null
var is_attacking = false
var health = 5

func _ready():
	# Thiết lập thời gian kêu ngẫu nhiên lần đầu (từ 3 đến 8 giây)
	idle_timer.wait_time = randf_range(2.0, 5.0)

func _on_idle_timer_timeout():
	# 1. Phát âm thanh nếu Zombie còn sống và đang ở gần người chơi
	if not zombie_sound.playing:
		# Chỉnh pitch thấp xuống cho nghe "già" và đáng sợ hơn trên máy Victus
		zombie_sound.pitch_scale = randf_range(0.7, 0.9)
		zombie_sound.play()
	
	# 2. Reset lại Timer với một khoảng thời gian ngẫu nhiên mới
	idle_timer.wait_time = randf_range(5.0, 12.0)
	idle_timer.start()

func _physics_process(_delta):
	target_player = get_tree().current_scene.get_node_or_null("Player")
	
	# Nếu chết hoặc đang đánh thì đứng yên không làm gì cả
	if health <= 0 or is_attacking: 
		return 
		
	if target_player:
		var distance = global_position.distance_to(target_player.global_position)
		
		# 1. KIỂM TRA TẤN CÔNG TRƯỚC
		if distance < attack_range:
			attack_player()
		else:
			# 2. NẾU Ở XA THÌ MỚI CHẠY NAVIGATION
			move_with_navigation()
	else:
		sprite.play("idle")
		velocity = Vector2.ZERO

func move_with_navigation():
	# Cập nhật mục tiêu và lấy hướng đi né vật cản
	nav_agent.target_position = target_player.global_position
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	
	velocity = direction * speed
	sprite.play("run")
	sprite.flip_h = direction.x < 0 # Quay mặt về phía Player
	
	move_and_slide()
	
	# MẸO FIX KẸT TRỤC Y: Nếu va chạm trực tiếp với Player thì đánh luôn
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Player":
			attack_player()

func attack_player():
	if is_attacking: return
	is_attacking = true
	velocity = Vector2.ZERO
	sprite.play("attack")
	
	# Đợi tay zombie vung ra
	await get_tree().create_timer(0.5).timeout 
	
	# Kiểm tra xem Player còn trong tầm không
	if target_player and global_position.distance_to(target_player.global_position) < attack_range:
		print("Player đã bị zombie tiêu diệt!")
		trigger_game_over()
	
	await sprite.animation_finished
	is_attacking = false

func trigger_game_over():
	var label = get_tree().current_scene.get_node("%GameOverLabel")
	var panel = get_tree().current_scene.get_node("%Panel2")
	var screen_fade = get_tree().current_scene.get_node("%ScreenFade")
	var anim_player = get_tree().current_scene.get_node("AnimationPlayer")
		
	sprite.play("idle")
	screen_fade.show()
	anim_player.play("fade_to_black") #
	label.text = "GAME OVER"
	label.modulate = Color.RED 
	panel.show()
	
	await get_tree().create_timer(7.0).timeout
	GameManager.reset_game()

func take_damage(amount):
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.3).timeout
	sprite.modulate = Color(1, 1, 1) 
	
	if health <= 0: 
		return
	
	health -= amount
	if health <= 0:
		velocity = Vector2.ZERO
		$CollisionShape2D.set_deferred("disabled", true)
		
		if has_node("ZombieSound"):
			$ZombieSound.pitch_scale = 1.5 
			$ZombieSound.play()
			
		sprite.play("death") 
		
		if get_parent().has_method("zombie_died"):
			get_parent().zombie_died()
			
		await sprite.animation_finished
		if $ZombieSound.playing:
			await $ZombieSound.finished
			
		queue_free()

func die():
	$CollisionShape2D.set_deferred("disabled", true)
	
	collision_layer = 0
	collision_mask = 0
	
	if has_node("ZombieSound"):
		$ZombieSound.pitch_scale = 1.5 
		$ZombieSound.play()
	
	if get_parent().has_method("zombie_died"):
		get_parent().zombie_died()
	
	await $ZombieSound.finished
	
	queue_free()
