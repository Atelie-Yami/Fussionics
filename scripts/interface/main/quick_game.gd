extends VBoxContainer


@onready var difficult_rich_text = $select_dificult/difficult
@onready var opponent_rich_text = $select_opponent/opponent

@onready var level_difficult = $Level

@onready var select_dificult_down = $select_dificult/down
@onready var select_dificult_up = $select_dificult/up

@onready var select_opponent_down = $select_opponent/down
@onready var select_opponent_up = $select_opponent/up

@onready var opponent_name = $select_opponent/opponent
@onready var difficult_name = $select_dificult/difficult
@onready var difficult_level = $Level
@onready var descrition = $descrition

var current_dificult: int = 0:
	set(value):
		current_dificult = clamp(value, 0, 4)
		difficult_name.text = "[center]" + tr(GameBook.PhaseConfig.keys()[current_dificult])
		for i in 5:
			difficult_level.get_child(i).visible = i <= current_dificult 

var current_opponent: int = 0:
	set(value):
		current_opponent = clamp(value, 0, GameBook.SAGAS.size() - 1)
		opponent_name.text = "[center]" + GameBook.SAGAS[current_opponent][GameBook.Campagn.NAME]
		descrition.text = "[center]" + tr("SAGA_" + str(current_opponent))


func _ready():
	difficult_name.text = "[center]" + tr(GameBook.PhaseConfig.keys()[0])
	descrition.text = "[center]" + tr("SAGA_" + str(0))
	
	select_dificult_up.pressed  .connect(func(): self.current_dificult += 1)
	select_dificult_down.pressed.connect(func(): self.current_dificult -= 1)
	select_opponent_up.pressed  .connect(func(): self.current_opponent += 1)
	select_opponent_down.pressed.connect(func(): self.current_opponent -= 1)


func _on_start_pressed():
	get_parent().animation(false)
	await get_tree().create_timer(0.5).timeout
	GameConfig.start_direct_game(current_opponent, current_dificult)
