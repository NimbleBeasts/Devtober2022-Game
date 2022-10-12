extends Control


var NOISE_SCALE: int = 1
const MAP_SIZE_X: int = 40
const MAP_SIZE_Y: int = 20

var rng := RandomNumberGenerator.new()

var gradient_limits = [0.8, 0.9, 0.8]

var random_value = 0

func create_map(seed: int) -> Dictionary:
	var world_noise = FastNoiseLite.new()
	world_noise.set_noise_type(FastNoiseLite.TYPE_PERLIN  )
	world_noise.set_frequency(0.1)
	world_noise.set_seed(seed)
	
	var forest_noise = FastNoiseLite.new()
	forest_noise.set_noise_type(FastNoiseLite.TYPE_PERLIN)
	forest_noise.set_frequency(0.1)
	forest_noise.set_seed(seed + 42)

	var image = Image.new() 
	image.create(MAP_SIZE_X, MAP_SIZE_Y, false, Image.FORMAT_RGBA8)
	
	var tile_count = [0, 0, 0, 0]
	
	var map_data = []
	
	for x in range(MAP_SIZE_X):
		var row = []
		for y in range(MAP_SIZE_Y):
			var pixel = (world_noise.get_noise_2d(float(x*NOISE_SCALE), float(y*NOISE_SCALE)) + 1) 
			
			if pixel < gradient_limits[0]:
				# Mountains
				image.set_pixel(x, y, Color("#654053")) 
				tile_count[2] += 1
				$TileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(3, 0))
				pixel = 2
			elif pixel < gradient_limits[1]:
				# Stones
				image.set_pixel(x, y, Color("#d1a67e")) 
				tile_count[1] += 1
				$TileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 1))
				pixel = 1
			else:
				var forest_pixel = (forest_noise.get_noise_2d(float(x*NOISE_SCALE), float(y*NOISE_SCALE)) + 1) 
				
				if forest_pixel < gradient_limits[2]:
					#Forest
					image.set_pixel(x, y, Color("#3c6b64")) 
					tile_count[3] += 1
					$TileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(2, 0))
					pixel = 3
				else:
					#Gras
					image.set_pixel(x, y, Color("#60ae7b")) 
					tile_count[0] += 1
					$TileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0))
					pixel = 0
			
			row.append(pixel)
		map_data.append(row)
	
	var texture = ImageTexture.create_from_image(image)

	return {
		"map": map_data,
		"seed": seed,
		"distribution": tile_count,
		"preview_texture": texture
	}




# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	create_map(123)
	
	$Window/LimitBottom.value = gradient_limits[0]
	$Window/LimitTop.value = gradient_limits[1]
	$Window/LimitForest.value = gradient_limits[2]


func _on_button_button_up():
	random_value = rng.randi()
	create_map(random_value)



func _on_toggle_button_up():
	if $Window.visible:
		$Window.hide()
	else:
		$Window.show()


func _on_scale_slider_value_changed(value):
	NOISE_SCALE = $Window/ScaleSlider.value
	create_map(random_value)


func _on_limit_bottom_value_changed(value):
	gradient_limits[0] = $Window/LimitBottom.value
	create_map(random_value)


func _on_limit_top_value_changed(value):
	gradient_limits[1] = $Window/LimitTop.value
	create_map(random_value)


func _on_limit_forest_value_changed(value):
	gradient_limits[2] = $Window/LimitForest.value
	create_map(random_value)
