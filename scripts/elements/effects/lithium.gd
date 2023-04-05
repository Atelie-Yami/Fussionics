extends SkillEffect
## LITHIUM[br][br]
## [b]Efeito solo:[/b][br]
## Ative a autodestruição, causando [code]incêndio[/code] nos inimigos ao redor.[br]
## [code]Incêndio[/code] reduz 1 neutron a cada turno por valor acumulado, destroi o elemento caso seus neutrons chegue a 0.[br]
## Esse efeito pode acumular até 8 vezes.
## [br][br]
## [b]Efeito na molecula:[/b][br] 
## Antes de atacar, consome todos os [code]incêndios[/code] no alvo, causando dano igual a quantidade de [code]incêndios[/code] removidos.
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
			burn.stack = 1
			burn.origin = e
			burn.element = e
			e.debuffs[PassiveEffect.Debuff.BURNING] = burn
	
	Gameplay.arena.remove_element(element.grid_position)


func get_targets(cluster: EffectCluster, target: Element):
	cluster.targets = [target]


func molecule_effect(cluster: EffectCluster):
	for target in cluster.targets:
		if target.debuffs.has(PassiveEffect.Debuff.BURNING):
			var burn: PassiveEffect = target.debuffs[PassiveEffect.Debuff.BURNING]
			(target.debuffs as Dictionary).erase(PassiveEffect.Debuff.BURNING)
			target.neutrons -= burn.stack




