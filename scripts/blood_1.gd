extends AnimatedSprite2D

func _ready() -> void:
	randomize()
	
	speed_scale = randf_range(0.7, 1.5)
	
	frame = randi() % sprite_frames.get_frame_count("blood")
	await get_tree().create_timer(randf_range(0.0, 0.2)).timeout
	
	play("blood")
	
	await animation_finished
	queue_free()
