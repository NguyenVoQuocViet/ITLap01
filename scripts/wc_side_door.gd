extends AnimatedSprite2D # Giống SideDoor của bạn

var is_player_near = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = true
		play("open") # Cửa tự mở khi bạn lại gần

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = false
		play("open", -1.0, true) # Đóng cửa khi đi xa

func _input(event):
	if event.is_action_pressed("interact") and is_player_near:
		if GameManager.washed_face:
			# PHẢI GỌI HÀM NÀY ĐỂ ĐÁNH DẤU VỊ TRÍ TRƯỚC KHI ĐI
			exit_to_hallway() 
		else:
			# Nếu chưa rửa mặt mà đòi ra
			var label = get_node("%DialogueLabel")
			var panel = get_node("%Panel")
			label.text = "Phải rửa mặt đã..."
			panel.show()
			await get_tree().create_timer(2.0).timeout
			panel.hide()

func exit_to_hallway():
	# 1. Lấy node ScreenFade và AnimationPlayer
	var screen_fade = get_tree().current_scene.get_node("%ScreenFade")
	var anim_player = get_tree().current_scene.get_node("AnimationPlayer")
	
	# 2. Hiện node và chạy hiệu ứng tối dần
	screen_fade.show()
	anim_player.play("fade_to_black")
	
	# 3. PHẢI ĐỢI animation chạy xong thì mới được đổi cảnh
	await anim_player.animation_finished
	
	# 4. Đánh dấu điểm xuất hiện ở hành lang
	GameManager.spawn_location = "from_wc"
	
	# 5. Chuyển cảnh an toàn
	print("Đang rời khỏi nhà vệ sinh...")
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Hallway.tscn")
