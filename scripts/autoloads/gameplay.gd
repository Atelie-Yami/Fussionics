extends Node

signal show_action_buttons(actions)
signal element_selected(valid)

enum ElementActions {ATTACK, LINK, UNLINK, EFFECT}
enum ActionState {NORMAL, ATTACK, LINK, UNLINK}

const SLOT_INTERACT_INDICATOR := preload("res://scripts/vfx/slot_interact_indicator.gd")
const ACTION_BUTTON := preload("res://scenes/elements/element_action_button.tscn")

var time: float = 0.0

var token: String

var canvas := CanvasLayer.new()
var element_drag_preview := Node2D.new()
var element_focus := Sprite2D.new()

var in_link_state: bool
var in_unlink_state: bool

var arena: Arena
var element_info: Control
var passive_status: Node2D
var slot_interact_indicator: Control = SLOT_INTERACT_INDICATOR.new()
var attack_omega_handler: Control

var callback_action: int
var selected_element_target: Element:
	set(value):
		selected_element_target = value
		
		if selected_element_target:
			callback_action_target(selected_element_target)

var selected_element: Element:
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
		element_focus.position = selected_element.position + Vector2(40, 40)
		
		time += delta
		var scale = abs(cos(time * 4.0)) * 0.1
		element_focus.scale = Vector2(1.0 + scale, 1.0 + scale)
	
	if element_drag_preview.visible:
		element_drag_preview.position = element_drag_preview.get_global_mouse_position()


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("mouse_click") or event.is_action_pressed("ui_cancel"):
		action_state = ActionState.NORMAL
		passive_status.set_element(null)


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		element_drag_preview.visible = true
	
	if what == NOTIFICATION_DRAG_END:
		element_drag_preview.visible = false
		for c in element_drag_preview.get_children(): c.queue_free()


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
				GameJudge.charge_eletrons_to_attack(selected_element, slot.molecule)
				slot.eletrons_charged = true
			
			slot_interact_indicator.set_slots(arena.elements, 0)
			action_state = ActionState.ATTACK
		
		ElementActions.LINK:
			action_state = ActionState.LINK
			slot_interact_indicator.set_slots(arena.elements, 1, selected_element.grid_position)
		
		ElementActions.UNLINK:
			action_state = ActionState.UNLINK
			slot_interact_indicator.set_slots(selected_element.links, 2, selected_element.grid_position)
		
		ElementActions.EFFECT:
			selected_element.skill_effect.execute()
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
	
	if slot.skill_used:
		return
	
	if slot.element.molecule_effect:
		if (
				slot.element.molecule_effect.molecule_effect_type == MoleculeEffect.MoleculeEffectType.TRIGGER or
				slot.element.molecule_effect.molecule_effect_type == MoleculeEffect.MoleculeEffectType.MULTI
		):
			actions.append(ElementActions.EFFECT)
	
	if slot.element.skill_effect and slot.element.skill_effect.skill_type == BaseEffect.SkillType.ACTION:
		actions.append(ElementActions.EFFECT)
	
	return actions


func _disable_to_normal_state():
	callback_action = -1
	selected_element = null
	selected_element_target = null
	attack_omega_handler.visible = false
	slot_interact_indicator.set_slots({}, 2)
	slot_interact_indicator.element_in_action.x = 20
