class_name SaveLoad extends RefCounted

const SAVE_DIR_PATH := "user://system/"
const SAVE_NAME_PATH := "system.sv"
const SAVE_MODEL := {
		"campaign_progress": 0,
		"volume_master": false,
		"widgets_deck": [[], [], [0, 1], [], [], [], [], [2, 2], [], [], [], []], # [atomic_numer, ranking]
		"widgets": {
		#   atomic_numer: [isotopo_id, isotopo_id, isotopo_id]
		}
}


static func save_data(sv: Dictionary):
	check_directiry()
	var file = FileAccess.open(SAVE_DIR_PATH + SAVE_NAME_PATH, FileAccess.WRITE)
	if file:
		file.store_var(sv)
		file.close()


static func load_data(sv: Dictionary):
	check_directiry()
	var file = FileAccess.open(SAVE_DIR_PATH + SAVE_NAME_PATH, FileAccess.READ)
	if not file:
		sv = SAVE_MODEL.duplicate(true)
		save_data(sv)
		return
	
	var new_sv = file.get_var()
	file.close()
	
	if new_sv is Dictionary:
		for item in SAVE_MODEL:
			if new_sv.has(item):
				continue
			
			new_sv[item] = SAVE_MODEL[item]
		sv = new_sv
	else:
		sv = SAVE_MODEL.duplicate(true)
		save_data(sv)
		return


static func check_directiry():
	var dir := DirAccess.open(SAVE_DIR_PATH)
	if not dir:
		DirAccess.make_dir_absolute(SAVE_DIR_PATH)

