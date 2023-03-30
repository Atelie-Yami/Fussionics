extends SkillEffect
## Efeito: [i]Recupera saude do omega se for usado em um acelerador.[/i]


func _init():
	skill_type = SkillType.COOKED_ACCELR
	register(0)


func execute():
	if not active:
		return
	
	if Gameplay.player_controller.current_players[0].life < Gameplay.player_controller.PLAYERS_MAX_LIFE:
		Gameplay.player_controller.heal(0, 1)
