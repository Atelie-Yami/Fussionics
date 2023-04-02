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


func molecule_effect(molecule: Molecule):
	var H_list :Array[Element]
	var enemies: Array[Element]
	
	for e in molecule.configuration:
		if e.atomic_number == 0:
			H_list.append(e)
	
	for h in H_list:
		get_neighbor_enemies(h.grid_position, enemies)
	
	molecule.effect.targets = enemies


func get_neighbor_enemies(position: Vector2i, enemies: Array[Element]):
	var player = Gameplay.arena.elements[position].player
	
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var _pos = position + Vector2i(x, y)
			if Gameplay.arena.elements.has(_pos) and Gameplay.arena.elements[_pos].player != player:
				enemies.append(Gameplay.arena.elements[_pos].element)


