extends AnimatedSprite2D

var is_player_near = false

# 1. Xử lý tự động mở/đóng cửa khi lại gần
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = true
		play("open")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = false
		play("open", -1.0, true)

# 2. Xử lý nhấn phím E
func _input(event):
	if event.is_action_pressed("interact") and is_player_near:
		if GameManager.ready_to_go_home:
			transition_to_next_day()
		else:
			show_warning("Làm bài đi!!")

# 3. Hàm thực hiện hiệu ứng và chuyển ngày
func transition_to_next_day():
	print("Bắt đầu chuyển ngày...")
	
	# PHẢI HIỆN NODE LÊN TRƯỚC KHI CHẠY ANIMATION
	var screen_fade = get_tree().current_scene.get_node("%ScreenFade")
	screen_fade.show() 
	
	play("open") # Cửa mở
	
	var anim_player = get_parent().get_node("AnimationPlayer")
	# Đảm bảo animation bắt đầu từ giây thứ 0
	anim_player.play("fade_to_black") 
	
	await anim_player.animation_finished
	
	GameManager.current_day = 3
	GameManager.ready_to_go_home = false 
	if GameManager.day3_task_done == true:
		GameManager.spawn_location = "from_classroom"
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Hallway.tscn")

# Hàm hiện thông báo phụ
func show_warning(text):
	var label = get_node("%DialogueLabel")
	var panel = get_node("%Panel")
	label.text = text
	panel.show()
	await get_tree().create_timer(2.0).timeout
	panel.hide()
