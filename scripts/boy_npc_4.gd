extends CharacterBody2D

@onready var name_label = $NameLabel        # Node hiện tên
@onready var dialogue_label = $Panel/DialogueLabel # Node hiện lời thoại
@onready var panel = $Panel

func _ready():
	# Thiết lập ban đầu
	name_label.visible = true
	dialogue_label.visible = false
	dialogue_label.visible_ratio = 0

func start_interaction():
	# 1. Ẩn tên nhân vật
	name_label.visible = false
	
	# 2. Hiện lời thoại và chạy hiệu ứng đánh máy
	panel.visible = true
	dialogue_label.visible = true
	dialogue_label.visible_ratio = 0
	var tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, 1.0) # Chạy trong 1 giây

func end_interaction():
	# 1. Ẩn lời thoại
	dialogue_label.visible = false
	dialogue_label.visible_ratio = 0
	panel.visible = false
	# 2. Hiện lại tên nhân vật
	name_label.visible = true

# Kết nối tín hiệu từ Area2D
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		start_interaction()

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		end_interaction()
