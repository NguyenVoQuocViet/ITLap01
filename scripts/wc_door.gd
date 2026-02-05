extends AnimatedSprite2D

@onready var panel = $Panel
var is_player_near = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = true
		play("open") 
		panel.visible = true # Hiện chữ "Phòng vệ sinh"
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_near = false
		play("open", -1.0, true) 
		panel.visible = false

func _input(event):
	if event.is_action_pressed("interact") and is_player_near:
		enter_wc()

func enter_wc():
	# Chỉ cho vào nếu là Ngày 3 và đã làm xong bài
	if GameManager.current_day == 3 and GameManager.day3_task_done == true:
		print("Đang vào nhà vệ sinh...")
		
		# 1. Hiện node ScreenFade và chạy hiệu ứng tối dần
		var screen_fade = get_tree().current_scene.get_node("%ScreenFade")
		var anim_player = get_parent().get_node("AnimationPlayer") 
		
		screen_fade.show()
		anim_player.play("fade_to_black") #
		
		# 2. Đợi hiệu ứng chạy xong mới chuyển cảnh
		await anim_player.animation_finished
		
		# 3. Chuyển sang scene WC
		get_tree().change_scene_to_file("res://scenes/WC.tscn")
	else:
		# Hiện thông báo nếu chưa đủ điều kiện
		var diag_label = get_tree().current_scene.get_node("%WCLabel")
		var diag_panel = get_tree().current_scene.get_node("%Panel2")
		diag_label.text = "Chưa muốn đi vệ sinh"
		diag_panel.show()
		await get_tree().create_timer(2.0).timeout
		diag_panel.hide()
