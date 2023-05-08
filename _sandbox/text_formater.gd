@tool
extends Node





@export var bake: bool:
	set(value):
		var final: String
		var file = FileAccess.open("res://_sandbox/text1.txt", FileAccess.READ)
		var content = file.get_as_text()
		
#		var file2 = FileAccess.open("res://_sandbox/text2.txt", FileAccess.READ)
#		var content2 = file2.get_as_text()
		
		var some_array := content.split("\n")
		
#		content = content.replace(" ", "")
#
#		var some_array := content.split("\n")
#		var some_array2 := content2.split("\n")
#
#
		for i in some_array.size():
			var string = (some_array[i] as String).left(-2) + ", RANKING: " + str(randi() % 4) + "},"






