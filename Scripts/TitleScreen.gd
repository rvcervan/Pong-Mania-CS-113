extends Node



func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	Global.choseLevel = false

func _process(delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func _physics_process(delta):
	# start button, followed by exit button. (LEVEL SELECT IN PROGRESS)
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton3.is_hovered() == true:
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton3.grab_focus()


func _on_TextureButton_pressed():
	# start game button
	Global.state = "start"
	get_tree().change_scene("res://Scenes/DialogueScene.tscn")


func _on_TextureButton2_pressed():
	# exit game button
	get_tree().quit()


func _on_TextureButton3_pressed():
	# needs to make another levelScreen
	get_tree().change_scene("res://Scenes/LevelSelectScreen.tscn")
	
