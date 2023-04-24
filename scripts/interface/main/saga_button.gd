extends Button


@export var saga_id: int

@export var campaign_path: NodePath
@onready var campaign = get_node(campaign_path)

@export var backgroud_path: NodePath
@onready var backgroud = get_node(backgroud_path)

@export var phases_path: NodePath
@onready var phases: Control = get_node(phases_path)

@export var boss_descition_path: NodePath
@onready var boss_descition: Control = get_node(boss_descition_path)

@onready var progress = $ProgressBar
@onready var saga_name = $name


func _ready():
	saga_name.text = GameBook.SAGAS[saga_id][GameBook.Campagn.NAME]
	
	if saga_id == GameConfig.save.campaign_progress:
		var max: float = GameBook.SAGAS[saga_id][GameBook.Campagn.PHASES_CONFIG].size()
		progress.value = GameConfig.save.saga_progress / max
	
	elif saga_id > GameConfig.save.campaign_progress:
		disabled = true
	
	elif saga_id < GameConfig.save.campaign_progress:
		progress.value = 1.0
	
	if saga_id > GameConfig.save.campaign_progress + 1:
		visible = false


func _is_pressed():
	phases.load_saga(saga_id)
	backgroud.load_images(
			GameBook.SAGAS[saga_id][GameBook.Campagn.SKINS_BACKGROUND],
			GameBook.SAGAS[saga_id][GameBook.Campagn.COLOR]
	)
	
	boss_descition.boss_name.text = GameBook.SAGAS[saga_id][GameBook.Campagn.NAME]
	boss_descition.boss_info.text = tr("SAGA_" + str(saga_id))
	boss_descition.animation(true)
	
	campaign.animation(false)
