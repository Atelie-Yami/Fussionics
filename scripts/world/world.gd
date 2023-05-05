extends Node2D


@onready var passive_status = $passive_status
@onready var element_info = $info_panel/element_info
@onready var attack_omega = $Player_B/attack_omega
@onready var vfx = $VFX


func _init():
	Gameplay.world = self



