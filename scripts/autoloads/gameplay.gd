extends Node

signal show_action_buttons(actions)
signal element_selected(valid)

enum ElementActions {ATTACK, LINK, UNLINK, EFFECT}
enum ActionState {NORMAL, ATTACK, LINK, UNLINK}

const ACTION_BUTTON := preload("res://scenes/elements/element_action_button.tscn")

var time: float = 0.0

var token: String

var canvas := CanvasLayer.new()
var element_drag_preview := Node2D.new()
var element_focus := Sprite2D.new()

var in_link_state: bool
var in_unlink_state: bool
var arena: Arena

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
		
		match action_state:
			ActionState.NORMAL:
				self.selected_element = null
				self.selected_element_target = null
				callback_action = -1


func _ready():
	add_child(element_focus)
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


func _unhandled_input(event):
	if (event.is_action("mouse_click") or event.is_action("ui_cancel")) and event.is_pressed():
		self.action_state = ActionState.NORMAL


func _notification(what: int):
	if what == NOTIFICATION_DRAG_BEGIN:
		element_drag_preview.visible = true
	
	if what == NOTIFICATION_DRAG_END:
		element_drag_preview.visible = false
		for c in element_drag_preview.get_children(): c.queue_free()


func _action_pressed(action: ElementActions):
	callback_action = action
	match action:
		ElementActions.ATTACK:
			if arena.combat_in_process or not GameJudge.can_element_attack(selected_element):
				return
			
			self.action_state = ActionState.ATTACK
		
		ElementActions.LINK:
			self.action_state = ActionState.LINK
		
		ElementActions.UNLINK:
			self.action_state = ActionState.UNLINK
		
		ElementActions.EFFECT:
			arena.element_use_effect(selected_element)


func callback_action_target(target: Element):
	match callback_action:
		ElementActions.ATTACK:
			arena.attack_element(
					selected_element.grid_position, selected_element_target.grid_position, 0
			)
		
		ElementActions.LINK:
			arena.link_elements(selected_element, selected_element_target)
		
		ElementActions.UNLINK:
			arena.unlink_elements(selected_element, selected_element_target)
	
	self.action_state = ActionState.NORMAL


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
	
	if (
			slot.element.effect and not slot.skill_used and (
					slot.element.effect.molecule_effect_type == SkillEffect.MoleculeEffectType.TRIGGER or
					slot.element.effect.molecule_effect_type == SkillEffect.MoleculeEffectType.MULTI
			)
	):
		actions.append(ElementActions.EFFECT)
	
	return actions
