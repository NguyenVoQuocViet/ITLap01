extends Label

func _ready() -> void:
	# Bắt đầu vòng lặp ngay khi game hiện Menu
	start_typewriter_and_backspace_loop()

func start_typewriter_and_backspace_loop():
	while true:
		# --- GIAI ĐOẠN 1: GÕ CHỮ ---
		visible_ratio = 0.0
		var tween_in = create_tween()
		# Chữ hiện ra trong 1.5 giây
		tween_in.tween_property(self, "visible_ratio", 1.0, 2.5).set_trans(Tween.TRANS_LINEAR)
		await tween_in.finished
		
		# Đợi 2 giây để người chơi đọc tên Lab
		await get_tree().create_timer(2.0).timeout
		
		# --- GIAI ĐOẠN 2: XÓA CHỮ ---
		var tween_out = create_tween()
		# Chữ biến mất ngược lại từ cuối về đầu trong 1.0 giây
		tween_out.tween_property(self, "visible_ratio", 0.0, 2.5).set_trans(Tween.TRANS_LINEAR)
		await tween_out.finished
		
		# Đợi 0.5 giây trước khi bắt đầu gõ lại từ đầu
		await get_tree().create_timer(0.5).timeout
