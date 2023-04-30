extends CanvasLayer


@onready var player_a = $"../Player_A"

@onready var deck = $deck
@onready var signboard = $signboard
@onready var widgets = $widgets

@onready var pause_meun = $pause_meun
@onready var blur = $blur
@onready var energy = $deck/energy
@onready var next_turn = $signboard/next_turn
@onready var timer = $signboard/timer
@onready var h_box_container = $deck/HBoxContainer
@onready var end_game = $end_game

@onready var info_panel = $"../info_panel"

@onready var turn_machine = %turn_machine


func _process(delta):
	energy.text = str(player_a.energy)
	
	match turn_machine.current_stage:
		0: timer.text = tr("PRE_INIT")
		1: timer.text = tr("INIT_STORVE")
		3: timer.text = tr("END")
	
	if turn_machine.current_stage == 2:
		timer.text = tr("OPP_TURN") if turn_machine.current_player else tr("YOU_TURN")
		timer.text +=  str(int(turn_machine.time_left))


func _turn_machine_main_turn(player):
	next_turn.disabled = player != TurnMachine.Players.A
	
	if player == PlayerController.Players.A:
		h_box_container.get_children().map(func(c): c.can_drop = true)


func _turn_machine_end_turn(player):
	next_turn.disabled = true
	h_box_container.get_children().map(func(c): c.can_drop = false)


func _next_turn_pressed():
	turn_machine.next_phase()


func _turn_machine_end_game(win: bool):
	info_panel.visible = false
	pause_meun.visible = false
	signboard.visible = false
	widgets.visible = false
	deck.visible = false
	
	if win and GameConfig.game_match.progress_mode:
		GameConfig.advance_progress()
	
	await get_tree().create_timer(2.0).timeout
	next_turn.disabled = true
	end_game.end(win)
	
	blur.lod = 1.7
	if not win:
		blur.saturation = 0.1


