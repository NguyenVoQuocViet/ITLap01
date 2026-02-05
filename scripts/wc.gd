extends Node2D

var near_sink = false
var is_message_showing = false 

func _ready():
	%ScreenFade.show()
	%ScreenFade.modulate.a = 1.0
	$AnimationPlayer.play("fade_from_black")
	await get_tree().create_timer(1.0).timeout
	show_message("Đến bồn rửa mặt", false, false) 
	await $AnimationPlayer.animation_finished
	%ScreenFade.hide()

func _on_sink_area_body_entered(body):
	if body.name == "Player":
		near_sink = true

func _on_sink_area_body_exited(body):
	if body.name == "Player":
		near_sink = false

func _input(event):
	if is_message_showing or not near_sink:
		return

	if event.is_action_pressed("interact"):
		if not GameManager.washed_face:
			GameManager.washed_face = true
			show_message("Đã rửa mặt xong. Quay về phòng học thôi...", false, true) 
			await get_tree().create_timer(1.0).timeout
			near_sink = false
		elif GameManager.washed_face and near_sink:
			show_message("Bạn đã rửa mặt rồi, nhanh lên kẻo trễ học!", false, true)
			near_sink = false

func show_message(text, should_lock = false, block_input = true):
	is_message_showing = block_input
	
	if should_lock:
		GameManager.is_interacting = true 
	
	var label = %DialogueLabel
	var panel = %Panel
	
	label.text = text
	panel.show()
	
	await get_tree().create_timer(2.0).timeout
	
	panel.hide()
	
	GameManager.is_interacting = false 
	is_message_showing = false
