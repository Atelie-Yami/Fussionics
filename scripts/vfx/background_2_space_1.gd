extends CanvasLayer

const SCREEN_CENTER := Vector2(960, 540)
const POSITIONS_OFFSET := [Vector2.ZERO, Vector2.ZERO, SCREEN_CENTER]
const POSITIONS_DIFFERENCE := [50, 350, 200]
const DELAYS := [0.03, 0.05, 0.04]
const NODES_AMOUNT := 3

var position_offset: Vector2
var position_updatables: Array[PositionUpdatable]

class PositionUpdatable:
	var node: Node2D
	var position_offset: Vector2
	var position_difference: float
	var delay: float
	
	func update(mouse_position: Vector2, _position_offset: Vector2):
		node.position = lerp(
				node.position,
				position_offset + (mouse_position / position_difference) - _position_offset,
				delay
		)


func _ready():
	var nodes := [$layer_1, $layer_2, $particles]
	
	for i in NODES_AMOUNT:
		position_updatables.append(PositionUpdatable.new())
		
		position_updatables[i].node = nodes[i]
		position_updatables[i].position_offset = POSITIONS_OFFSET[i]
		position_updatables[i].position_difference = POSITIONS_DIFFERENCE[i]
		position_updatables[i].delay = DELAYS[i] 


func _process(delta):
	var mouse_position: Vector2 = ($layer_1.get_global_mouse_position() - SCREEN_CENTER)
	update_positions(mouse_position, position_offset)


func update_positions(mouse_position: Vector2, _position_offset: Vector2):
	for i in NODES_AMOUNT:
		position_updatables[i].update(mouse_position, _position_offset)

