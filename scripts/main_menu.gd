extends ParallaxBackground

@onready var title_label = $TitleLabel
@export var swing_distance = 30.0 
@export var duration = 8.0
var is_mobile = false

func _ready() -> void:
	is_mobile = OS.get_name() in ["Android", "iOS"]
	start_swinging_effect()

func _on_play_button_pressed() -> void:
	# Chuyển đến màn chơi đầu tiên (ví dụ: Hành lang Ngày 2)
	get_tree().change_scene_to_file("res://scenes/Hallway.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

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
	if not is_mobile:
		%ControlsPanel.show()


func _on_controls_button_mouse_exited() -> void:
	if not is_mobile:
		%ControlsPanel.hide()


func _on_controls_button_pressed() -> void:
	if is_mobile:
		%ControlsPanel2.visible = !%ControlsPanel2.visible
		%ControlsPanel.hide()
	else:
		%ControlsPanel.visible = !%ControlsPanel.visible
