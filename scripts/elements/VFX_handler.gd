extends Timer

enum SkillName {
	LASER, BULLET, ORB, LIGHTNING
}


## SkillName: [ tempo de ação ]
const DATA := {
	SkillName.LASER: [0.3],
	SkillName.BULLET: [0.15],
	SkillName.ORB: [0.3],
}

@onready var arena = $".."


func emite_attack(origin: Vector2i, target: Vector2i, efx_id: SkillName):
	print(origin, " atacou ", target, " usando ", efx_id)
	
	start(DATA[efx_id][0])


func _timeout():
	arena.combat_in_process = false
