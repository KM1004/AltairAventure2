extends Node2D

var tile_size = Vector2(16, 16)
onready var texture = $Sprite.texture


func _ready():
	var tex_width = int(texture.get_width() / tile_size.x)
	var tex_height = int(texture.get_height() / tile_size.y)
	
	var ts = TileSet.new()
	var image = texture.get_data()
	image.lock()
	
	for y in range(tex_height):
		for x in range(tex_width):
			
				var region = Rect2(x * tile_size.x, y * tile_size.y,
									tile_size.x,tile_size.y)
									
				#skip empty tiles
				if is_tile_empty(image, region):
					continue
					
				var id = x + y * tex_width
				
				ts.create_tile(id)
				ts.tile_set_texture(id, texture)
				ts.tile_set_region(id, region)
				
	image.unlock()
	ResourceSaver.save("res://TileMapSets/volcanoterrain_tiles1.tres", ts)
	
func is_tile_empty(image, region):
	for yy in range(
		int(region.position.y), 
		int(region.position.y + region.size.y)
		):
		for xx in range(
			int(region.position.x), 
			int(region.position.x + region.size.x)
			):
			
			var pixel = image.get_pixel(xx, yy)
			
			#check alpha
			if pixel.a > 0:
				return false
	return true
