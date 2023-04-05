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


func _init(_element: Element):
	element = _element
	skill_type = SkillType.COOKED_ACCELR
	molecule_effect_type = MoleculeEffectType.MECHANICAL
	mechanic_mode = MechanicMode.CONTROLLER
	register(0)


func execute():
	if not active:
		return
	
	Gameplay.arena.current_players[0].heal(1)


func molecule_effect(cluster: EffectCluster):
	var H_list :Array[Element]
	var enemies: Array[Element]
	
	for e in cluster.molecule.configuration:
		if e.atomic_number == 0:
			H_list.append(e)
	
	for h in H_list:
		GameJudge.get_neighbor_enemies(h.grid_position, enemies)
	
	cluster.targets = enemies

