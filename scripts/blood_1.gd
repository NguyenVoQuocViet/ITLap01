extends AnimatedSprite2D


func _ready() -> void:
	# 1. Khởi tạo bộ tạo số ngẫu nhiên
	randomize()
	
	# 2. Ngẫu nhiên hóa tốc độ chạy (ví dụ từ 0.7x đến 1.5x tốc độ thường)
	speed_scale = randf_range(0.7, 1.5)
	
	# 3. Ngẫu nhiên hóa frame bắt đầu (để các vệt máu không giống hệt nhau ở giây đầu)
	frame = randi() % sprite_frames.get_frame_count("blood")
	
	# 4. (Tùy chọn) Thêm một khoảng trễ cực ngắn trước khi chạy để tránh bị giật
	await get_tree().create_timer(randf_range(0.0, 0.2)).timeout
	
	# 5. Chạy hiệu ứng
	play("blood")
	
	# 6. Tự xóa sau khi xong để tiết kiệm RAM cho máy Victus
	await animation_finished
	queue_free()
