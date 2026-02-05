extends ParallaxBackground

@onready var title_label = $TitleLabel
@export var swing_distance = 30.0 
@export var duration = 8.0

func _on_play_button_pressed() -> void:
	# Chuyển đến màn chơi đầu tiên (ví dụ: Hành lang Ngày 2)
	get_tree().change_scene_to_file("res://scenes/Hallway.tscn")

func _on_quit_button_pressed() -> void:
	# Thoát ứng dụng
	get_tree().quit()

func _ready() -> void:
	start_swinging_effect()

func start_swinging_effect():
	# Tạo một Tween lặp lại vô tận
	var tween = create_tween().set_loops()
	
	# Giai đoạn 1: Đưa sang phải
	tween.tween_property(self, "scroll_offset:x", swing_distance, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Giai đoạn 2: Đưa ngược lại sang trái
	tween.tween_property(self, "scroll_offset:x", -swing_distance, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_controls_button_mouse_entered() -> void:
	%ControlsPanel.show()


func _on_controls_button_mouse_exited() -> void:
	%ControlsPanel.hide()
