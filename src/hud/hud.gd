extends CanvasLayer

@export var gm_ref: NodePath
var gm: Object = null


func _ready():
	if gm_ref == null:
		printerr("HUD: Reference to GM not set.")
	
	gm = get_node(gm_ref)
	
	# Start with Main
	_menu_switch("MainMenu")

func _menu_switch(to: String):
	for menu in $Menu.get_children():
		if menu.name != to:
			menu.hide()
		else:
			if menu.has_method("init"):
				menu.init(self)
			menu.show()



func _on_continue_game_button_up():
	Events.emit_signal("S_Menu_Button_Click")


func _on_new_game_button_up():
	Events.emit_signal("S_Menu_Button_Click")
	_menu_switch("NewGame")


func _on_options_button_up():
	Events.emit_signal("S_Menu_Button_Click")
	_menu_switch("Options")


func _on_quit_button_up():
	Events.emit_signal("S_Menu_Button_Click")


func _on_back_button_up():
	Events.emit_signal("S_Menu_Button_Click")
	_menu_switch("MainMenu")
