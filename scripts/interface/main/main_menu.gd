extends Control
class_name GuiMenu

enum State {
	MAIN_MENU, CAMPAIGN, QUICK_GAME, CONFIG, DECK
}

@export var Settings:Control

@onready var buttons = $Buttons
@onready var links = $links
@onready var campaign = $campaign/campaign
@onready var deck = $deck/Deck


var state: State:
	set(value):
		state = value
		_machine()


func _machine():
	campaign.animation(state == State.CAMPAIGN)
	buttons.animation(state == State.MAIN_MENU)
	links.animation(state == State.MAIN_MENU)
	deck.animation(state == State.DECK)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		state = State.MAIN_MENU


