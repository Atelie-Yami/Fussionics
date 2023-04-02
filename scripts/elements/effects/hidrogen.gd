extends SkillEffect

## HIDROGEN[br][br]
## [b]Efeito solo:[/b][br]
## [i]Recupera saude do [b][code]Omega[/code][/b] se for usado em um acelerador.[/i][br][br]
## [b]Efeito na molecula:[/b][br] 
## [i]Efeitos prejudiciais de alvo passarão a afetar todos os inimigos entorno de qualquer [code]HIDROGEN[/code] desta molecula.[/i][br][br]
## [codeblock]
## MoleculeEffectType:   MECHANICAL
## TargetMode:           AREA
## MechanicMode:         CONTROLLER
## [/codeblock]


func _init():
	skill_type = SkillType.COOKED_ACCELR
	register(0)


func execute():
	if not active:
		return
	
	Gameplay.arena.current_players[0].heal(1)
