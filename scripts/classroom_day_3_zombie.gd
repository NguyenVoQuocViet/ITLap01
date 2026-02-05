extends Node2D

# Tham chiếu đến các node UI bằng Unique Name
@onready var screen_fade = %ScreenFade
@onready var dialogue_panel = %Panel
@onready var dialogue_label = %DialogueLabel

func _ready() -> void:
	GameManager.day3_zombies_killed = 0
	GameManager.day3_mission_complete = false
	# 1. Đảm bảo lúc mới vào màn hình phải đen hoàn toàn
	screen_fade.show()
	screen_fade.modulate.a = 1.0
	dialogue_panel.hide() # Ẩn khung chữ đi trước
	
	# 2. Hiệu ứng mờ dần (Fade in) từ đen sang trong suốt
	# Chúng ta dùng Tween để làm hiệu ứng mượt mà trên máy Victus
	var tween = create_tween()
	tween.tween_property(screen_fade, "modulate:a", 0.0, 2.0) # Mờ dần trong 2 giây
	show_start_mission("TIÊU DIỆT HẾT ZOMBIE")
	# Đợi hiệu ứng mờ dần kết thúc
	await tween.finished
	screen_fade.hide()
	
func zombie_died():
	GameManager.day3_zombies_killed += 1
	
	if GameManager.day3_zombies_killed >= 5:
		GameManager.day3_mission_complete = true

func show_start_mission(text: String):
	# Gán nội dung và hiện khung chữ
	dialogue_label.text = text
	dialogue_label.modulate = Color.WHITE # Đảm bảo chữ màu trắng dễ nhìn
	dialogue_panel.show()
	
	# Đợi 3 giây để người chơi kịp đọc rồi ẩn đi
	await get_tree().create_timer(3.0).timeout
	dialogue_panel.hide()
