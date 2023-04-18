extends SkillEffect
## HIDROGEN[br][br]
## [b]Efeito solo:[/b][br]
## [i]Recupera saude do [b][code]Omega[/code][/b] se for usado em um acelerador.[/i][br][br]


func _init(_element: Element):
	element = _element
	skill_type = SkillType.COOKED_ACCELR
	mechanic_mode = MechanicMode.SPECIAL


func execute():
	Gameplay.arena.current_players[0].heal(1)
