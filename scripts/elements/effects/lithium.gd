extends SkillEffect
## LITHIUM[br][br]
## [b]Efeito solo:[/b][br]
## Ative a autodestruição, causando [code]incêndio[/code] acumulado 3x nos inimigos ao redor.[br]
## [code]Incêndio[/code] reduz 1 neutron a cada turno por valor acumulado, destroi o elemento caso seus neutrons chegue a 0.[br]
## Esse efeito pode acumular até 8 vezes.
## [br][br]
## [b]Efeito na molecula:[/b][br] 
## Antes de atacar, consome até 8 elétrons dos outros elementos da sua molecula para aplicar [code]incêndio[/code] acumulado em até 8x no alvo e reduzindo seus neutrons.[br]
## Não sofre contra-ataque.
## [codeblock]
## MoleculeEffectType:   TRIGGER
## TargetMode:           SINGLE
## MechanicMode:         DESTROYER
## [/codeblock]


func _init(_element: Element):
	element = _element
	skill_type = SkillType.ACTION
	molecule_effect_type = MoleculeEffectType.TRIGGER
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
					e.effect, Gameplay.arena.elements[e.grid_position].player
			)
			burn.origin = e
			burn.stack = 3
			burn.element = e
			e.debuffs[PassiveEffect.Debuff.BURNING] = burn
	
	Gameplay.arena.remove_element(element.grid_position)


func molecule_effect(molecule: Molecule):
	pass


