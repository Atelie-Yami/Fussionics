extends Node2D


@onready var passive_status = $passive_status
@onready var element_info = $info_panel/element_info
@onready var attack_omega = $Player_B/attack_omega



func _init():
	Gameplay.world = self


func handle_vfx(positions: Array[Vector2], type: VFX.Type, id: int):
	pass
