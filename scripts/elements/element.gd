## Classe que define os elementos.
class_name Element extends ElementRender


var effect #: BaseEffect


func _ready():
	mouse_entered.connect(_mouse_entered)
	mouse_exited .connect(_mouse_exited )


func _input(event: InputEvent):
	if event.is_action_pressed("test"):
		await Gameplay.world.vfx.emit_end_vfx(self)


func _exit_tree():
	if Gameplay.selected_element == self:
		Gameplay.selected_element = null
	
	if effect:
		effect.unregister()


func can_link(ref: Element):
	if number_electrons_in_valencia == 0:
		return false
	
	if not has_link:
		return true
	
	for link in links:
		if links[link] and links[link].level < 3 and (links[link].element_A == ref or links[link].element_B == ref):
			return true
	
	for link in links:
		if not links[link]:
			return true
	
	return false


func build(_atomic_number: int):
	atomic_number = min(_atomic_number, GameBook.ELEMENTS.size())
	eletrons = atomic_number + 1
	neutrons = atomic_number
	valentia = GameBook.ELEMENTS[atomic_number][GameBook.VALENCY]
	tooltip_text = GameBook.ELEMENTS[atomic_number][GameBook.NAME]


func reset():
	disabled = false
	if debuffs.is_empty() and neutrons > 0:
		neutrons = atomic_number
		
	eletrons = atomic_number +1


func _mouse_entered():
	if active:
		_set_current_node_state(NodeState.HOVER)
	
	mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func _mouse_exited():
	if active:
		_set_current_node_state(NodeState.NORMAL)


func _is_neighbor_to_link():
	var x: int = abs(Gameplay.selected_element.grid_position.x - grid_position.x)
	var y: int = abs(Gameplay.selected_element.grid_position.y - grid_position.y)
	return (x == 1 and y != 1) or (x != 1 and y == 1)
