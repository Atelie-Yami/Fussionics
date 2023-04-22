class_name PlayerController extends Control

enum Players {A, B}

const GRID_OFFSET := Vector2i(605, 320)
const SLOT_SIZE := Vector2i(90, 90)

@onready var current_players: Array[Player] = [
	$"../Player_A" as Player,
	$"../Player_B" as Player,
]
@onready var turn_machine: TurnMachine = %turn_machine


func _ready():
	turn_machine.pre_init_turn.connect(_pre_init_turn)
	turn_machine.main_turn.connect(_set_current_player_controller)
	turn_machine.end_turn.connect(_remove_players_control)
	turn_machine.start_game.connect(_start_game)
	
	await  get_tree().create_timer(0.1).timeout
	
	for c in get_children():
		await  get_tree().create_timer(0.03).timeout
		c.animation()


func _gui_input(event):
	if event.is_action_pressed("mouse_click"):
		Gameplay.action_state = Gameplay.ActionState.NORMAL
		Gameplay.passive_status.set_element(null)


func _start_game():
	current_players[turn_machine.current_player].energy_max -= 1


func _pre_init_turn(player: Players):
	pass


func _set_current_player_controller(player: Players):
	current_players[player].set_turn(true)
	current_players[player].energy_max += 1
	current_players[player].energy = current_players[player].energy_max
	current_players[player].play.emit()


func _remove_players_control(player: Players):
	current_players[player].set_turn(false)
	
	await ElementEffectManager.call_effects(player, BaseEffect.SkillType.END_PHASE)
	
	if player == Players.A:
		pass


func _check_slot_only_out(slot: Vector2i):
	return slot.y == 12 or slot.y == 15 or slot.y == 18 or slot.y == 21


func _get_snapped_slot_position(slot: Vector2i):
	var _slot = (slot - Vector2i(16, 0)) if slot.x > 11 else slot
	return (SLOT_SIZE * _slot) + GRID_OFFSET


func _link_elements(element_a: Element, element_b: Element):
	for link in element_a.links:
		var ligament_a = element_a.links[link]
		if not ligament_a:
			continue
		
		for _link in element_b.links:
			var ligament_b = element_b.links[_link]
			if not ligament_b:
				continue
			
			if ligament_a == ligament_b and ligament_a.level < 3:
				ligament_a.evolve_ligament()
				return


func _unlink_elements(element_A: Element, element_B: Element):
	for link in element_A.links:
		var ligament_A: Molecule.Ligament = element_A.links[link]
		if not ligament_A:
			continue
		
		for _link in element_B.links:
			var ligament_B: Molecule.Ligament = element_B.links[_link]
			if not ligament_B:
				continue
			
			if ligament_A == ligament_B:
				if ligament_A.level > 1:
					ligament_A.demote_ligament()
				
				else:
					ligament_A.remove()
				
				return true
	return false


func _procedural_search_link_nodes(element_parent: Element, anchored_array: Array[Element]):
	for l in element_parent.links:
		var link: Molecule.Ligament = element_parent.links[l]
		if not link: continue
		
		if link.element_A == element_parent:
			_procedural_search_test(link.element_B, anchored_array)
		
		elif link.element_B == element_parent:
			_procedural_search_test(link.element_A, anchored_array)


func _procedural_search_test(element: Element, anchored_array: Array[Element]):
	if anchored_array.find(element) != -1:
		return
	
	anchored_array.append(element)
	_procedural_search_link_nodes(element, anchored_array)


func _can_drop_data(_p, data):
	return (
			turn_machine.current_stage == TurnMachine.State.MAIN
			and turn_machine.current_player == TurnMachine.Players.A
	)



