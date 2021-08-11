extends Node2D

export var next_scene_string = "res://Scenes/InvisibleGame.tscn";

var finishedDialogue

const BUMMY_INTRO = "Bummy: You think you can beat me? I’m just the start of it all. You\'re not good at anything, Bimmy!"
const BUMMY_DEFEAT = "Bummy: His muscles… are too strong… *death noise*"
const HADES_INTRO = "Hades: You can\'t see me."
const HADES_DEFEAT = "Hades: My time is now."
const HYDRA_INTRO = "Hydra: What makes you think you match up to Hercules to face me?"
const HYDRA_DEFEAT = "Hydra: Don\'t talk to me or my sons ever again."
const JIM_INTRO = "Jim from IT: username: soulEater password: kiLL81mmy. How about you try and defeat my debugger debuffs."
const JIM_DEFEAT = "Jim from IT: ERR 139: Segfault error"
const CHIRON_INTRO = "Chiron: Everything\'s better with lasers."
const CHIRON_DEFEAT = "Chiron: You’re not ready for the next battle. Just know that."
const HERMES_INTRO = "Hermes: Prepare for die."
const HERMES_DEFEAT = "Hermes: I... am die?" 

# Called when the node enters the scene tree for the first time.
func _ready():
	finishedDialogue = false
	next_scene_string = getNextScene()
	setBossImage()
	$DialogueBox/Dialogue.clear()
	$DialogueBox/Dialogue.set_visible_characters(0)
	$DialogueBox/Dialogue.add_text(getText())


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if !finishedDialogue:
			$DialogueBox/Dialogue.set_visible_characters(len(getText()))
			finishedDialogue = true
		else:
			Global.state = "start"
			print("switch scene")
			get_tree().change_scene(next_scene_string)


func getText():
	if Global.state == "won":
		# Get a defeat quote
		if Global.previousLevel == "res://Scenes/StandardGame.tscn":
			return BUMMY_DEFEAT
		elif Global.previousLevel == "res://Scenes/InvisibleGame.tscn":
			return HADES_DEFEAT
		elif Global.previousLevel == "res://Scenes/MinionGame.tscn":
			return HYDRA_DEFEAT
		elif Global.previousLevel == "res://Scenes/ThreeInOneGame.tscn":
			return JIM_DEFEAT
		elif Global.previousLevel == "res://Scenes/SpaceInvaderGame.tscn":
			return CHIRON_DEFEAT
		elif Global.previousLevel == "res://Scenes/BulletHellGame.tscn":
			return HERMES_DEFEAT
	elif Global.state == "start":
		# Get an intro quote
		if Global.previousLevel == "":
			return BUMMY_INTRO
		elif Global.previousLevel == "res://Scenes/StandardGame.tscn":
			return HADES_INTRO
		elif Global.previousLevel == "res://Scenes/InvisibleGame.tscn":
			return HYDRA_INTRO
		elif Global.previousLevel == "res://Scenes/MinionGame.tscn":
			return JIM_INTRO
		elif Global.previousLevel == "res://Scenes/ThreeInOneGame.tscn":
			return CHIRON_INTRO
		elif Global.previousLevel == "res://Scenes/SpaceInvaderGame.tscn":
			return HERMES_INTRO
	return ""
	
	
func setBossImage():
	if Global.state == "won":
		if Global.previousLevel == "res://Scenes/StandardGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/BummyBossImage.png")
		elif Global.previousLevel == "res://Scenes/InvisibleGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/HermesInvisibleImage.png")
		elif Global.previousLevel == "res://Scenes/MinionGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/HydraBossImage_minion.png")
		elif Global.previousLevel == "res://Scenes/ThreeInOneGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/jimFromITBossImage.png")
		elif Global.previousLevel == "res://Scenes/SpaceInvaderGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/ChironBossImage.png")
		elif Global.previousLevel == "res://Scenes/BulletHellGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/BulletHellBossImage.png")
	elif Global.state == "start":
		if Global.previousLevel == "":
			$"Boss Image".texture = load("res://bossImageScripts/BummyBossImage.png")
		elif Global.previousLevel == "res://Scenes/StandardGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/HermesInvisibleImage.png")
		elif Global.previousLevel == "res://Scenes/InvisibleGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/HydraBossImage_minion.png")
		elif Global.previousLevel == "res://Scenes/MinionGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/jimFromITBossImage.png")
		elif Global.previousLevel == "res://Scenes/ThreeInOneGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/ChironBossImage.png")
		elif Global.previousLevel == "res://Scenes/SpaceInvaderGame.tscn":
			$"Boss Image".texture = load("res://bossImageScripts/BulletHellBossImage.png")
	
	
func getNextScene():
	if Global.state == "won":
		if Global.previousLevel != "res://Scenes/BulletHellGame.tscn":
			return "res://Scenes/DialogueScene.tscn"
		else:
			return "res://Scenes/Win.tscn"
	elif Global.state == "start":
		if Global.previousLevel == "":
			return "res://Scenes/StandardGame.tscn"
		elif Global.previousLevel == "res://Scenes/StandardGame.tscn":
			return "res://Scenes/InvisibleGame.tscn"
		elif Global.previousLevel == "res://Scenes/InvisibleGame.tscn":
			return "res://Scenes/MinionGame.tscn"
		elif Global.previousLevel == "res://Scenes/MinionGame.tscn":
			return "res://Scenes/ThreeInOneGame.tscn"
		elif Global.previousLevel == "res://Scenes/ThreeInOneGame.tscn":
			return "res://Scenes/SpaceInvaderGame.tscn"
		elif Global.previousLevel == "res://Scenes/SpaceInvaderGame.tscn":
			return "res://Scenes/BulletHellGame.tscn"
			


func _on_Timer_timeout():
	$DialogueBox/Dialogue.set_visible_characters($DialogueBox/Dialogue.get_visible_characters() + 1)
	if $DialogueBox/Dialogue.get_visible_characters() == len(getText()):
		finishedDialogue = true
	if !finishedDialogue:
		$Timer.start()
