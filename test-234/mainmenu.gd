extends Control

enum MENU_STATE {MAIN, OPTIONS, SCREEN, AUDIO, CONTROLS, GAME_SETTINGS}
var curr_menu_state : MENU_STATE = MENU_STATE.MAIN
var waiting_for_rebind : String = ""

@onready var input_list := $CONTROLS/Avail_Inputs


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_menu("MAIN")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if waiting_for_rebind == "":
		return

	if event.is_pressed() and not event.is_echo():
		InputMap.action_erase_events(waiting_for_rebind) #remove old binding
		InputMap.action_add_event(waiting_for_rebind, event) #add new binding
		
		#update input list UI
		for child in input_list.get_children():
			var label = child.get_child(0)
			var button = child.get_child(1)
			if label.text == waiting_for_rebind.capitalize():
				button.text = get_current_binding(waiting_for_rebind)
				break
			
		waiting_for_rebind = ""

func _on_play_pressed() -> void:
	
	get_tree().change_scene_to_file("res://node_2d.tscn")



func _on_exit_pressed() -> void:

	get_tree().quit()

func change_menu(menu_name:String):
	for child in get_children():
		if child.name == menu_name:
			child.visible = true
		else:
			child.visible = false
	curr_menu_state = MENU_STATE[menu_name]

func _on_options_pressed() -> void:
	change_menu("OPTIONS")

func _on_screen_pressed() -> void:
	change_menu("SCREEN")


func populate_available_inputs():
	for child in input_list.get_children():
		for children in child.get_children():
			children.queue_free()
		child.queue_free()
	var array = InputMap.get_actions()
	for action in array:
		print(action)
		if action.ends_with("debug") or action.begins_with("ui"): #good for disabling things like debug buttons
			continue
			
		var hbox_temp = HBoxContainer.new()
		var label_temp = Label.new()
		label_temp.text = action.capitalize()
		label_temp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var button_temp = Button.new()
		button_temp.text = get_current_binding(action)
		button_temp.pressed.connect(_on_rebind_button_pressed.bind(action, button_temp))
		
		hbox_temp.add_child(label_temp)
		hbox_temp.add_child(button_temp)
		input_list.add_child(hbox_temp)
		
	pass

func _on_rebind_button_pressed(action, button):
	waiting_for_rebind = action
	button.text = "Press Any Key..."
	


func get_current_binding(binding:String) -> String:
	var input = InputMap.action_get_events(binding)
	if input.size() > 0:
		var inp = input[0]
		if inp is InputEventKey:
			return OS.get_keycode_string(inp.physical_keycode)
		elif inp is InputEventMouseButton:
			return "Mouse " + str(inp.button_index)
		elif inp is InputEventJoypadButton:
			return "Button " + str(inp.button_index)
	return "Unbound"


func _on_audio_pressed() -> void:
	change_menu("AUDIO")

func _on_controls_pressed() -> void:
	change_menu("CONTROLS")
	populate_available_inputs()

func _on_game_settings_pressed() -> void:
	change_menu("GAME_SETTINGS")


func _on_back_pressed() -> void:
	if curr_menu_state == MENU_STATE.OPTIONS:
		change_menu("MAIN")
	else:
		change_menu("OPTIONS")
