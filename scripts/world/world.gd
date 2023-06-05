@static_unload
class_name Gameplay extends Node2D

signal set_to_default
signal show_action_buttons(actions)
signal is_element_selected(has_element: bool)

enum ElementActions {ATTACK, DEFEND, LINK, UNLINK, EFFECT}
enum ActionState {NORMAL, ATTACK, LINK, UNLINK}

static var selected_element: Element = null:
	set(value):
		if selected_element:
			selected_element.selected = false
		
		selected_element = value
		
		if not world:
			return
		
		if selected_element:
			world.element_selected()
		else:
			actions.visible = false
			world.is_element_selected.emit(false)

static var selected_element_target: Element:
	set(value):
		selected_element_target = value
		
		if selected_element_target and world:
			world.callback_action_target(selected_element_target)

static var callback_action: int
static var action_state: ActionState:
	set(value):
		action_state = value
		
		if action_state == ActionState.NORMAL and world:
			world.disable_to_normal_state()

static var slot_interact_indicator: Control
static var element_drag_preview: Node2D
static var attack_omega: TextureRect
static var passive_status: Node2D
static var element_info: Control
static var actions: Node2D
static var arena: Arena
static var vfx: VFX

static var world: Gameplay




func _ready():
	vfx = $VFX
	arena = $arena
	actions = $actions
	passive_status = $passive_status
	attack_omega = $Player_B/attack_omega
	element_info = $info_panel/element_info
	element_drag_preview = $element_drag_preview
	slot_interact_indicator = $slot_interact_indicator
	
	world = self


func _process(delta):
	if element_drag_preview.visible:
		element_drag_preview.position = element_drag_preview.get_global_mouse_position()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("mouse_click") or event.is_action_pressed("ui_cancel"):
		action_state = ActionState.NORMAL


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		element_drag_preview.visible = true
	
	if what == NOTIFICATION_DRAG_END:
		element_drag_preview.visible = false
		element_drag_preview.get_children().map(func(c): c.queue_free())


func _exit_tree():
	world = null


func element_selected():
	show_action_buttons.emit(
			slot_get_actions( Arena.elements[selected_element.grid_position] )
	)
	is_element_selected.emit(true)
	selected_element.selected = true


func slot_get_actions(slot: ArenaSlot):
	var actions: Array[ElementActions]
	
	if slot.element.has_link:
		if slot.element.number_electrons_in_valencia > 0:
			actions.append(ElementActions.LINK)
		
		if PlayerController.current_players[slot.player].energy > 0:
			actions.append(ElementActions.UNLINK)
		
	else:
		if slot.element.number_electrons_in_valencia > 0:
			actions.append(ElementActions.LINK)
	
	if not slot.can_act:
		return actions
	
	actions.append(ElementActions.ATTACK)
	
	if not slot.defend_mode:
		actions.append(ElementActions.DEFEND)
	
	if slot.skill_used:
		return
	
	if not slot.element.effect:
		return actions
	
	if slot.element.effect is MoleculeEffect:
		var is_action: bool = (
				slot.element.effect.molecule_effect_type == MoleculeEffect.MoleculeEffectType.TRIGGER or
				slot.element.effect.molecule_effect_type == MoleculeEffect.MoleculeEffectType.MULTI
		)
		if is_action and slot.molecule:
			actions.append(ElementActions.EFFECT)
	
	elif slot.element.effect.skill_type == BaseEffect.SkillType.ACTION:
		actions.append(ElementActions.EFFECT)
	
	return actions


func action_pressed(action: ElementActions):
	callback_action = action
	slot_interact_indicator.element_in_action = selected_element.grid_position
	
	if arena.action_in_process:
		return
	
	match action:
		ElementActions.ATTACK:
			if not GameJudge.can_element_attack(selected_element):
				return
			
			var slot: ArenaSlot = Arena.get_slot(selected_element.grid_position)
			
			if slot and slot.molecule and not slot.eletrons_charged:
				GameJudge.charge_eletrons_power(selected_element, slot.molecule)
				slot.eletrons_charged = true
			
			slot_interact_indicator.set_slots(Arena.elements, 0)
			action_state = ActionState.ATTACK
		
		ElementActions.DEFEND:
			if not GameJudge.can_element_defend(selected_element):
				return
			
			await arena.defend_mode(selected_element.grid_position)
			action_state = ActionState.NORMAL
		
		ElementActions.LINK:
			action_state = ActionState.LINK
			slot_interact_indicator.set_slots(Arena.elements, 1, selected_element.grid_position)
		
		ElementActions.UNLINK:
			action_state = ActionState.UNLINK
			slot_interact_indicator.set_slots(selected_element.links, 2, selected_element.grid_position)
		
		ElementActions.EFFECT:
			selected_element.effect.execute()
			action_state = ActionState.NORMAL


func callback_action_target(target: Element):
	match callback_action:
		ElementActions.ATTACK:
			arena.attack_element(selected_element.grid_position, selected_element_target.grid_position)
		
		ElementActions.LINK:
			arena.link_elements(selected_element, selected_element_target)
		
		ElementActions.UNLINK:
			arena.unlink_elements(selected_element, selected_element_target)
	
	action_state = ActionState.NORMAL


func disable_to_normal_state():
	callback_action = -1
	selected_element = null
	selected_element_target = null
	
	set_to_default.emit()
	slot_interact_indicator.set_slots({}, 2)
	slot_interact_indicator.element_in_action.x = 20
