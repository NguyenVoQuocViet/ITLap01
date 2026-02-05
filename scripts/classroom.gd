extends Node2D

# Trong Classroom.gd
# Trong Classroom.gd
func _ready():
	# 1. Bắt đầu với màn hình đen đặc
	%ScreenFade.show()
	%ScreenFade.color.a = 1.0
	
	# 2. Chạy hiệu ứng mờ dần từ đen sang trong suốt
	$AnimationPlayer.play("fade_from_black")
	
	# Đợi hiệu ứng chạy xong rồi mới hiện chữ ngày mới
	await get_tree().create_timer(1.0).timeout
	show_day_intro()
	await get_tree().create_timer(2.0).timeout
	%ScreenFade.hide() # Ẩn đi để không cản trở tương tác
	


func show_day_intro():
	var label = get_node("%DialogueLabel")
	var panel = get_node("%Panel")
	
	if GameManager.current_day == 2:
		label.text = "THỨ 2"
		GameManager.correct_task = 0
	elif GameManager.current_day == 3:
		label.text = "THỨ 3"
		# Tông màu u ám của ngày 3
		if has_node("CanvasModulate"):
			$CanvasModulate.color = Color("2d335a")
			
	panel.show()
	await get_tree().create_timer(2.0).timeout
	panel.hide()
