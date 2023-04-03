extends PassiveEffect.DebuffEffect


var player: PlayerController.Players
var element: Element


func _init(o: SkillEffect, _player: PlayerController.Players):
	type = PassiveEffect.Debuff.BURNING
	cust_type = PassiveEffect.PassiveEffectLifetimeType.TEMPORAL
	life_time = 3
	max_stacks = 8
	origin = o
	player = _player
	register(player)


func effect():
	if not element:
		call_deferred("unregister", player)
		return
	
	element.neutrons -= stack
	element.max_neutrons = element.neutrons
	life_time -= 1
	
	if life_time <= 0:
		remove()


func remove():
	element.max_neutrons = 0
	element.debuffs.erase(type)
