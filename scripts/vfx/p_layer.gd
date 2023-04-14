extends ParallaxLayer

@export var speed : float = 5

func _process(delta):
	motion_offset.y += speed * delta
