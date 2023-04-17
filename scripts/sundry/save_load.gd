class_name SaveLoad extends RefCounted

const SAVE_DIR_PATH := "user://system/"
const SAVE_NAME_PATH := "system.sv"
const SAVE_MODEL := {
		"campaign_progress" : 0,
		"volume_master" : false
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
		save_data(SAVE_MODEL.duplicate())
		return SAVE_MODEL.duplicate()
	
	var new_sv = file.get_var()
	file.close()
	
	if new_sv is Dictionary:
		for item in SAVE_MODEL:
			if new_sv.has(item):
				continue
			
			new_sv[item] = SAVE_MODEL[item]
		
		return new_sv
	else:
		save_data(SAVE_MODEL.duplicate())
		return SAVE_MODEL.duplicate()


static func check_directiry():
	var dir := DirAccess.open(SAVE_DIR_PATH)
	if not dir:
		DirAccess.make_dir_absolute(SAVE_DIR_PATH)

