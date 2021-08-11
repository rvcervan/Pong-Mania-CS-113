extends Node


func _ready():
	$MarginContainer/VBoxContainer/TextureButton.grab_focus()
	
func _process(delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func _physics_process(delta):
	# level 1-6, and the back button
	if $MarginContainer/VBoxContainer/TextureButton.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton2.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton2.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton3.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton3.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton4.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton4.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton5.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton5.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton6.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton6.grab_focus()
	if $MarginContainer/VBoxContainer/TextureButton7.is_hovered() == true:
		$MarginContainer/VBoxContainer/TextureButton7.grab_focus()

func _on_TextureButton_pressed():
	# standard level 1
	Global.choseLevel = true
	Global.state = "start"
	Global.previousLevel = ""
	get_tree().change_scene("res://Scenes/DialogueScene.tscn")

func _on_TextureButton2_pressed():
	# level 2 invisible (Hades)
	Global.choseLevel = true
	Global.state = "start"
	Global.previousLevel = "res://Scenes/StandardGame.tscn"
	get_tree().change_scene("res://Scenes/DialogueScene.tscn")


func _on_TextureButton3_pressed():
	# Level 3 (Minion)
	Global.choseLevel = true
	Global.state = "start"
	Global.previousLevel = "res://Scenes/InvisibleGame.tscn"
	get_tree().change_scene("res://Scenes/DialogueScene.tscn")

func _on_TextureButton4_pressed():
	# Level 4 (Jim from IT)
	Global.choseLevel = true
	Global.state = "start"
	Global.previousLevel = "res://Scenes/MinionGame.tscn"
	get_tree().change_scene("res://Scenes/DialogueScene.tscn")

func _on_TextureButton5_pressed():
	# Level 5 (Chiron) 
	Global.choseLevel = true
	Global.state = "start"
	Global.previousLevel = "res://Scenes/ThreeInOneGame.tscn"
	get_tree().change_scene("res://Scenes/DialogueScene.tscn")

func _on_TextureButton6_pressed():
	# Level 6 (Hermes)
	Global.choseLevel = true
	Global.state = "start"
	Global.previousLevel = "res://Scenes/SpaceInvaderGame.tscn"
	get_tree().change_scene("res://Scenes/DialogueScene.tscn")

func _on_TextureButton7_pressed():
	# back button
	Global.choseLevel = false
	get_tree().change_scene("TitleScreen.tscn")
