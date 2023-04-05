extends TileMap
class_name LineMap


func Update(Date:Array):
	clear()
	set_cells_terrain_connect(0,Date,0,0)
