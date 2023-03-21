class_name GameJudge extends RefCounted

enum Result {WINNER, COUNTERATTACK, DRAW}


func combat_check_result(element_attacker: ElementNode, element_defender: ElementNode, skill: int):
	
	# avaliar os efeitos pra saber se tem codições nesse caso atual
	
	if element_attacker.eletrons > element_defender.neutrons:
		return Result.WINNER
	
	elif element_attacker.eletrons == element_defender.neutrons:
		return Result.DRAW
	
	else:
		return Result.COUNTERATTACK
