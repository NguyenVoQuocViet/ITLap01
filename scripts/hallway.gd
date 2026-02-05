extends Node2D

func _ready():
	# 1. Đảm bảo màn hình đen hiện lên ngay lập tức khi vừa load
	if has_node("%ScreenFade"):
		var screen_fade = get_node("%ScreenFade")
		screen_fade.show()
		# Đặt Alpha về 1 (đen đặc) để bắt đầu
		screen_fade.color.a = 1.0 
		
	if GameManager.spawn_location == "from_classroom":
		$Player.global_position = $FromClassroomPos.global_position
	elif GameManager.spawn_location == "from_wc":
		$Player.global_position = $FromWCPos.global_position
	
	# Sau khi đặt vị trí xong thì xóa trắng biến để không bị lỗi cho lần sau
	GameManager.spawn_location = ""
	# 2. Chạy hiệu ứng mờ dần màu đen
	if has_node("AnimationPlayer"):
		# Bạn cần đảm bảo đã tạo animation tên "fade_from_black"
		$AnimationPlayer.play("fade_from_black")
		
		await get_tree().create_timer(2.0).timeout
		if GameManager.current_day == 2:
			show_opening_dialogue("Hôm nay sinh hoạt lớp web, đến phòng 205 thôi")
		elif GameManager.current_day == 3 and GameManager.day3_task_done == false:
			show_opening_dialogue("Hôm nay là NMLT thì phải...")
		# 3. Đợi chạy xong thì ẩn hẳn đi để không cản trở chuột/phím
		await $AnimationPlayer.animation_finished
		get_node("%ScreenFade").hide()


# Hàm hỗ trợ hiện lời thoại
func show_opening_dialogue(text: String):
	var label = get_node("%Label")
	var panel = get_node("%Panel3")
	
	label.text = text
	panel.show()
	
	# Đợi 4 giây để người chơi kịp đọc trên màn hình máy Victus
	await get_tree().create_timer(4.0).timeout
	panel.hide()
