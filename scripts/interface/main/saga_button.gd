extends Button


@export var saga_id: int

@export var phases_path: NodePath
@onready var phases: Control = get_node(phases_path)

@onready var texture_rect = $TextureRect
@onready var saga_name = $name


func _ready():
	saga_name.text = tr("SAGA_" + str(saga_id))


func _is_pressed():
	phases.load_saga(saga_id)
