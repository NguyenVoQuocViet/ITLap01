extends StaticBody2D

@onready var assignment_ui = get_tree().current_scene.get_node("%AssignmentUI")

func interact():
	# Sửa điều kiện: Cho phép làm bài ở cả ngày 2 và ngày 3
	if GameManager.current_day == 2:
		# Gọi bảng bài tập Ngày 2
		get_node("%AssignmentUI").show()
	elif GameManager.current_day == 3:
		# Gọi bảng bài tập Ngày 3 vừa tạo
		get_node("%AssignmentUI_Day3").show()
	else:
		show_message("Không phải giờ học, về thôi...")

func show_message(text):
	var panel = get_tree().current_scene.get_node("%Panel")
	var label = get_tree().current_scene.get_node("%DialogueLabel")
	panel.show()
	label.text = text
	await get_tree().create_timer(1.5).timeout
	panel.hide()
