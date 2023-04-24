extends VBoxContainer


@onready var title = $title
@onready var rich_text_label = $RichTextLabel

@onready var next = $HBoxContainer/next
@onready var restart = $HBoxContainer/restart


func _main_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/main_menu/main.tscn")


func _next_pressed():
	GameConfig.start_game(GameConfig.save.campaign_progress, GameConfig.save.saga_progress)


func _restart_pressed():
	GameConfig.restart_game()
