extends Button


@export var saga_id: int

@export var phases_path: NodePath
@onready var phases: Control = get_node(phases_path)

@onready var progress = $ProgressBar
@onready var saga_name = $name


func _ready():
	saga_name.text = tr("SAGA_" + str(saga_id))
	
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
