class_name BotChip extends RefCounted
## classe que detem as caracteristicas e modus operandi do bot


class FieldAnalysis:
	var my_molecules: Array[Array]
	var my_single_elements: Array[Element]
	
	var rival_single_elements: Array[Element]
	var rival_molecules: Array[Array]
	
	var can_cook_double_oxygen: bool
	


func analysis(bot: Bot) -> FieldAnalysis:
	
	bot.start(1.0)
	await bot.timeout
	return FieldAnalysis.new()


func create_element(bot: Bot, atomic_number: int, position: Vector2i):
	var element = Gameplay.arena.create_element(atomic_number, PlayerController.Players.B, position, false)
	Gameplay.arena.current_players[PlayerController.Players.B].spend_energy(atomic_number + 1)
	
	bot.start(0.2)
	await bot.timeout
	return element


