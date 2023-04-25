@tool
extends Control

const SAGA_DEFAULT := {
	GameBook.Campagn.NAME: "",
	GameBook.Campagn.COLOR: "",
	GameBook.Campagn.SKINS_BACKGROUND: "",
	GameBook.Campagn.PHASES_CONFIG: 0,
	GameBook.Campagn.SKINS: 0,
	GameBook.Campagn.BOTS: 0,
}


@export var add_saga: bool:
	set(value):
		add_saga
		
		GameBook.Campagn.NAME


@export var Dick: Dictionary
