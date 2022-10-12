extends Control


var hud: Object

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var seed: int = 0
var map_data: Dictionary = {}


func _ready():
	rng.randomize()

func init(ref):
	hud = ref
	seed = rng.randi()
	$Seed.text = str(seed)
	_create_map()

func _create_map():
	if hud == null:
		printerr("NewGame: init was not called")
		return
	
	
#	return {
#		"map": map_data,
#		"seed": seed,
#		"distribution": tile_count,
#		"preview_texture": texture
#	}
	map_data = hud.gm.create_map(seed)
	
	if map_data.size() == 0:
		printerr("NewGame: Map creation error")
		return
	
	# Calculate difficulty
	var total = float(hud.gm.MAP_SIZE_X * hud.gm.MAP_SIZE_Y)
	var distribution = map_data.distribution
	var base_difficulty = 50 + int((distribution[0] / total) * 100)
	
	
	$Difficulty.set_text("Difficulty: " + str(base_difficulty) + "\n" + str(map_data.distribution))
	
	$MapPreview.texture = map_data.preview_texture




func _on_start_button_up():
	Events.emit_signal("S_Menu_Button_Click")


func _on_seed_text_changed():
	print("_on_seed_text_changed")
	if $Seed.text != str(seed):
		print("real change")

func _on_randomize_button_up():
	Events.emit_signal("S_Menu_Button_Click")
	seed = rng.randi()
	$Seed.text = str(seed)
	_create_map()
