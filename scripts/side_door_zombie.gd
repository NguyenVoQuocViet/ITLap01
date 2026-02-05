extends AnimatedSprite2D

var is_player_near = false

# 1. Xử lý tự động mở/đóng cửa khi lại gần
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = true
		if GameManager.day3_zombies_killed >= 5 and GameManager.correct_task >= 2:
			play("open")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = false
		if GameManager.day3_zombies_killed >= 5 and GameManager.correct_task >= 2:
			play("open", -1.0, true)

# 2. Xử lý nhấn phím E
func _input(event):
	if event.is_action_pressed("interact") and is_player_near:
		# 1. Kiểm tra xem đã diệt hết 5 Zombie chưa
		if GameManager.day3_mission_complete:
			check_and_load_ending()
		else:
			show_warning("Tiêu diệt tất cả Zombies")

func check_and_load_ending():
	# 1. Tìm node ScreenFade một cách chắc chắn nhất
	# Lệnh này sẽ tìm node tên "ScreenFade" ở bất cứ đâu trong màn chơi hiện tại
	var screen_fade = get_tree().current_scene.find_child("ScreenFade", true)
	
	if screen_fade:
		screen_fade.show()
		# Đảm bảo ban đầu nó trong suốt (Alpha = 0)
		screen_fade.modulate.a = 0.0 
		
		# 2. Tạo hiệu ứng chuyển đen mượt mà bằng Tween
		var tween = create_tween()
		# Làm cho thuộc tính alpha (a) tăng từ 0 lên 1 trong 1.5 giây
		tween.tween_property(screen_fade, "modulate:a", 1.0, 1.5)
		
		# 3. Đợi cho đến khi hiệu ứng kết thúc
		await tween.finished
		
		# 4. Kiểm tra điều kiện và chuyển cảnh
		if GameManager.correct_task >= 2:
			get_tree().change_scene_to_file("res://scenes/GoodEnding.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/BadEnding.tscn")
	else:
		# Nếu vẫn không tìm thấy node, máy Victus sẽ báo lỗi ở đây để bạn biết
		print("LỖI: Không tìm thấy node ScreenFade trong Scene này!")

func show_warning(text):
	var label = %DialogueLabel
	var panel = %Panel
	label.text = text
	panel.show()
	await get_tree().create_timer(2.0).timeout
	panel.hide()
