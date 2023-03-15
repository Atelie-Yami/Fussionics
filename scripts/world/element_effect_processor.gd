## Classe que define o sistema de qualquer processador de efeitos de elementos
class_name ElementEffectProcessor extends Timer

const TIME_EFFECT := 0.3
@export var time: Element.ActionTime

var elements_pool_interator: int
var elements_pool: Array[Element]

@onready var turn_machine: TurnMachine = $".."


func _init():
	one_shot = true
	timeout.connect(_timeout)


func _ready():
	match time:
		Element.ActionTime.PRE_INIT:
			turn_machine.pre_init_turn.connect(start_process)
		
		Element.ActionTime.INIT:
			turn_machine.init_turn.connect(start_process)
		
		Element.ActionTime.END_TURN:
			turn_machine.end_turn.connect(start_process)


func start_process():
	elements_pool_interator = 0
	process()


func process():
	if elements_pool_interator < elements_pool.size():
		active_element_effect(elements_pool[elements_pool_interator])
	
	else:
		turn_machine.next_phase()


func active_element_effect(element :Element):
	start(TIME_EFFECT)
	element.action_time[time].call()


func _timeout():
	elements_pool_interator += 1
	process()


