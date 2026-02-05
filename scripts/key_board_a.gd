extends Area2D

@export var speed = 400.0
@export var damage = 1
var direction = Vector2.RIGHT

func _process(delta):
	# Di chuyển bàn phím theo hướng đã định
	position += direction * speed * delta
	
	# Xoay bàn phím để trông giống như đang bị ném
	rotation += 15 * delta 

func _on_body_entered(body):
	# Nếu trúng Zombie thì gây sát thương
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free() 
		
	if body is TileMapLayer: 
		queue_free() # Chỉ biến mất khi trúng tường (TileMap)
