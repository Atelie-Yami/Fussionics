class_name BotChip extends RefCounted
## classe que detem as caracteristicas e modus operandi do bot


func analysis(bot: Bot):
	bot.breath_time.start(0.5)
	await bot.breath_time.timeout


func create_element(bot: Bot, atomic_number: int, position: Vector2i):
	var element = Gameplay.arena.create_element(atomic_number, PlayerController.Players.B, position, false)
	Gameplay.arena.current_players[PlayerController.Players.B].spend_energy(atomic_number + 1)
	
	bot.breath_time.start(0.2)
	await bot.breath_time.timeout
	return element


