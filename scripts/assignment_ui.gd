extends Panel

var has_answered = false 

# --- NÚT ĐÁP ÁN 1 ---
func _on_ans_1_pressed():
	if has_answered: return
	
	# Nếu là ngày 3 và Ans 1 là câu đúng bạn đã soạn
	if GameManager.current_day == 3:
		process_correct_answer()
	else:
		process_wrong_answer()

# --- NÚT ĐÁP ÁN 2 ---
func _on_ans_2_pressed():
	if has_answered: return
	
	# Nếu là ngày 2 và Ans 2 là câu đúng bạn đã soạn
	if GameManager.current_day == 2:
		process_correct_answer()
	else:
		process_wrong_answer()

# --- NÚT ĐÁP ÁN 3 ---
func _on_ans_3_pressed():
	if has_answered: return
	if GameManager.current_day == 2:
		process_wrong_answer()
	else:
		process_wrong_answer_day3()

# --- LOGIC XỬ LÝ CHUNG ---

func process_correct_answer():
	lock_assignment()
	if GameManager.current_day == 2:
		GameManager.day2_task_done = true
	else:
		GameManager.day3_task_done = true
	GameManager.correct_task += 1
	if GameManager.correct_task >= 2:
		show_result("Bạn nhận được chìa khóa!")
	else:
		show_result("Chính xác!")

func process_wrong_answer():
	lock_assignment()
	show_result("Sai rồi!")
	if GameManager.current_day == 2:
		GameManager.day2_task_done = true
	else:
		GameManager.day3_task_done = true

func process_wrong_answer_day3():
	lock_assignment()
	show_result("Chịu :D")
	if GameManager.current_day == 2:
		GameManager.day2_task_done = true
	else:
		GameManager.day3_task_done = true

func lock_assignment():
	has_answered = true
	$Ans1.disabled = true
	$Ans2.disabled = true
	$Ans3.disabled = true
	GameManager.ready_to_go_home = true # Làm xong là được về

func show_result(text):
	# Code hiện thông báo kết quả của bạn giữ nguyên
	$Label.text = text
	await get_tree().create_timer(2.0).timeout
	hide()
	
	# Hiện lời thoại nhắc nhở
	var diag_label = get_tree().current_scene.get_node("%DialogueLabel")
	var diag_panel = get_tree().current_scene.get_node("%Panel")
	if GameManager.current_day == 2:
		diag_label.text = "Xong rồi, về thôi..."
	else:
		diag_label.text = "Đi vệ sinh thôi..."
	diag_panel.show()
	await get_tree().create_timer(3.0).timeout
	diag_panel.hide()

func _on_close_button_pressed():
	hide()
