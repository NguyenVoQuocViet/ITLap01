extends CharacterBody2D

@onready var name_label = $AnimatedSprite2D/NameLabel
@onready var dialogue_label = $Panel/DialogueLabel
@onready var panel = $Panel

func _ready():
	name_label.visible = true
	dialogue_label.visible = false
	dialogue_label.visible_ratio = 0

func start_interaction():
	# 1. Ẩn tên nhân vật
	name_label.visible = false
	panel.visible = true
	dialogue_label.visible = true
	dialogue_label.visible_ratio = 0
	var tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, 1.0)

func end_interaction():
	dialogue_label.visible = false
	dialogue_label.visible_ratio = 0
	panel.visible = false
	name_label.visible = true

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		start_interaction()

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		end_interaction()
