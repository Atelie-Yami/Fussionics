extends Node

signal set_to_default
signal show_action_buttons(actions)
signal element_selected(valid)

enum ElementActions {ATTACK, DEFEND, LINK, UNLINK, EFFECT}
enum ActionState {NORMAL, ATTACK, LINK, UNLINK}

const SLOT_INTERACT_INDICATOR := preload("res://scripts/vfx/slot_interact_indicator.gd")
const ACTION_BUTTON := preload("res://scenes/elements/element_action_button.tscn")

var in_link_state: bool
var in_unlink_state: bool
var time: float = 0.0
var token: String

var callback_action: int
var selected_element_target: Element:
	set(value):
		selected_element_target = value
		
		if selected_element_target:
			callback_action_target(selected_element_target)

var selected_element: ElementBase:
	set(value):
		if selected_element:
			selected_element.selected = false
		
		selected_element = value
		
		if selected_element:
			show_action_buttons.emit(
					slot_get_actions( arena.elements[selected_element.grid_position] )
			)
			element_selected.emit(true)
			selected_element.selected = true
			element_focus.visible = true
			element_focus.modulate = selected_element.modulate
		else:
			element_focus.visible = false
			element_selected.emit(false)

var action_state := ActionState.NORMAL:
	set(value):
		action_state = value
		
		if action_state == ActionState.NORMAL:
			_disable_to_normal_state()

var slot_interact_indicator: Control = SLOT_INTERACT_INDICATOR.new()
var element_drag_preview := Node2D.new()
var element_focus := Sprite2D.new()
var canvas := CanvasLayer.new()

var world: Node2D
var arena: Arena


func _ready():
	add_child(element_focus)
	add_child(slot_interact_indicator)
	
	element_focus.visible = false
	element_focus.texture = preload("res://assets/img/elements/element_moldure4.png")
	
	for i in 4:
		element_focus.add_child(ACTION_BUTTON.instantiate())
		element_focus.get_child(i).action = i
	
	add_child(canvas)
	add_child(element_drag_preview)


func _process(delta):
	if selected_element:
		element_focus.global_position = selected_element.global_position + Vector2(40, 40)
		
		time += delta
		var scale = abs(cos(time * 4.0)) * 0.1
		element_focus.scale = Vector2(1.0 + scale, 1.0 + scale)
	
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


func _action_pressed(action: ElementActions):
	callback_action = action
	slot_interact_indicator.element_in_action = selected_element.grid_position
	
	if arena.action_in_process:
		return
	
	match action:
		ElementActions.ATTACK:
			if not GameJudge.can_element_attack(selected_element):
				return
			
			var slot = Gameplay.arena.elements[selected_element.grid_position]
			if slot.molecule and not slot.eletrons_charged:
				GameJudge.charge_eletrons_power(selected_element, slot.molecule)
				slot.eletrons_charged = true
			
			slot_interact_indicator.set_slots(arena.elements, 0)
			action_state = ActionState.ATTACK
		
		ElementActions.DEFEND:
			if not GameJudge.can_element_defend(selected_element):
				return
			
			await arena.defend_mode(selected_element.grid_position)
			action_state = ActionState.NORMAL
		
		ElementActions.LINK:
			action_state = ActionState.LINK
			slot_interact_indicator.set_slots(arena.elements, 1, selected_element.grid_position)
		
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


func slot_get_actions(slot: Arena.Slot):
	var actions: Array[ElementActions]
	
	if slot.element.has_link:
		if slot.element.number_electrons_in_valencia > 0:
			actions.append(ElementActions.LINK)
		
		if arena.current_players[slot.player].energy > 0:
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


func _disable_to_normal_state():
	callback_action = -1
	selected_element = null
	selected_element_target = null
	
	set_to_default.emit()
	
	slot_interact_indicator.set_slots({}, 2)
	slot_interact_indicator.element_in_action.x = 20
