extends Node2D


func _ready():
	$MarginContainer/VBoxContainer/TextureButton.grab_focus()

func _process(delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func _physics_process(delta):
	# Try again, main menu, exit game
	if $MarginContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton2.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton3.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton3.grab_focus()

func _on_TextureButton_pressed():
	# should be TRY AGAIN.
	# currently missing functionality. made it so
	# it goes to title screen as a placeholder
	get_tree().change_scene(Global.previousLevel)
	
	

func _on_TextureButton2_pressed():
	# main menu screen
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func _on_TextureButton3_pressed():
	# exits game
	get_tree().quit()
