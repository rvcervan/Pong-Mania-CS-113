extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_select"):
		# Pause the game and show the pause text
		get_tree().paused = not get_tree().paused
		visible = not visible
