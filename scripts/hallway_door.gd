extends AnimatedSprite2D # Giống SideDoor của bạn

var is_player_near = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = true
		play("open") # Cửa tự mở khi bạn lại gần
		
		var label = get_tree().current_scene.get_node("%DialogueLabel")
		var panel = get_tree().current_scene.get_node("%Panel")
		
		label.text = "Phòng 205"
		panel.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = false
		play("open", -1.0, true) # Đóng cửa khi đi xa
		
		var panel = get_tree().current_scene.get_node("%Panel")
		panel.hide()

func _input(event):
	# Khi nhấn E tại cửa hành lang
	if event.is_action_pressed("interact") and is_player_near:
		enter_classroom()

func enter_classroom():
	var screen_fade = get_tree().current_scene.get_node("%ScreenFade")
	screen_fade.show() 
	
	
	var anim_player = get_parent().get_node("AnimationPlayer")
	# Đảm bảo animation bắt đầu từ giây thứ 0
	anim_player.play("fade_to_black") 
	
	await anim_player.animation_finished
	print("Đang đi vào lớp học...")
	# Chuyển cảnh sang scene Classroom
	if GameManager.current_day == 3 and GameManager.washed_face == false:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Classroom_Day3.tscn")
	elif GameManager.current_day == 2:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Classroom.tscn")
	elif GameManager.current_day == 3 and GameManager.washed_face == true:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Classroom_Day3_Zombie.tscn")
