extends Label

# Độ dài chính xác của file âm thanh (giây)
var audio_duration: float = 3.7

@onready var type_sound = $AudioStreamPlayer

func _ready() -> void:
	# Đợi 0.5 giây cho người chơi ổn định rồi mới gõ
	play_synced_typewriter()

func play_synced_typewriter():
	# 1. Lấy nội dung chữ và tính toán tốc độ
	var content = text
	var char_count = content.length()
	
	var typing_speed = audio_duration / char_count
	
	visible_characters = 0
	type_sound.play() 
	
	for i in range(char_count):
		visible_characters += 1
		
		await get_tree().create_timer(typing_speed).timeout
	
	type_sound.stop()
	
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
