extends CanvasLayer

func _ready():
	var attack_btn = $Control/AttackButton
	var os_name = OS.get_name()
	
	if os_name == "Android" or os_name == "iOS":
		self.visible = true
	else:
		self.visible = false
		
	if GameManager.current_day == 3 and GameManager.washed_face == true:
		attack_btn.show()
	else:
		attack_btn.hide()
