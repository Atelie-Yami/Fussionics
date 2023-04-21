extends Node


var save: Dictionary = SaveLoad.SAVE_MODEL.duplicate(true)




func _ready():
	SaveLoad.load_data(save)

	print(preload("res://scripts/bots/bot_chip.gd"))
