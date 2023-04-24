class_name SaveLoad extends RefCounted

const SAVE_DIR_PATH := "user://system/"
const SAVE_NAME_PATH := "system.sv"
const SAVE_MODEL := {
		"campaign_progress": 0,
		"saga_progress": 0,
		"volume_master": false,
		"widgets_deck": GameBook.DECK,
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
	
		print("do")
	else:
		print("not")


static func load_data():
	check_directiry()
	var file = FileAccess.open(SAVE_DIR_PATH + SAVE_NAME_PATH, FileAccess.READ)
	if not file:
		var sv = SAVE_MODEL.duplicate(true)
		save_data(sv)
		return sv
	
	var new_sv = file.get_var()
	file.close()
	
	if new_sv is Dictionary:
		for item in SAVE_MODEL:
			if new_sv.has(item):
				continue
			
			new_sv[item] = SAVE_MODEL[item]
		return new_sv
	else:
		var sv = SAVE_MODEL.duplicate(true)
		save_data(sv)
		return sv


static func check_directiry():
	var dir := DirAccess.open(SAVE_DIR_PATH)
	if not dir:
		DirAccess.make_dir_absolute(SAVE_DIR_PATH)

