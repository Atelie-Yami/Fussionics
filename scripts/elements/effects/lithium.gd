extends SkillEffect
## LITHIUM[br][br]
## [b]Efeito solo:[/b][br]
## Ative a autodestruição, causando [code]incêndio[/code] nos inimigos ao redor.[br]
## [code]Incêndio[/code] reduz 1 neutron a cada turno por valor acumulado, destroi o elemento caso seus neutrons chegue a 0.[br]
## [br]
## Esse efeito pode acumular até 8 vezes.


func _init(_element: Element):
	player = _element.player
	element = _element
	skill_type = SkillType.ACTION
	mechanic_mode = MechanicMode.DESTROYER


func execute():
	var enemies: Array[Element]
	GameJudge.get_neighbor_enemies(element.grid_position, enemies)
	
	for e in enemies:
		if e.debuffs.has(PassiveEffect.Debuff.BURNING):
			e.debuffs[PassiveEffect.Debuff.BURNING].stack += 1
			e.debuffs[PassiveEffect.Debuff.BURNING].life_time = 3
		else:
			var burn = PassiveEffect.DEBUFF_BOOK[PassiveEffect.Debuff.BURNING].new(
					e.effect, player
			)
			burn.stack = 1
			burn.origin = e
			burn.element = e
			burn.life_time = 3
			e.debuffs[PassiveEffect.Debuff.BURNING] = burn
	
	Gameplay.arena.remove_element(element.grid_position, false)
