extends Node

var screenSize    # Vector2 to hold screen dimensions
var playerX = 20
var enemyX        # x-coordinate of enemy paddle
var playerScore
var enemyScore
const SCORE_TO_WIN = 7
#var g = Global.choseLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get screen dimensions
	#if Global.choseLevel: print(Global.choseLevel)
	Global.previousLevel = "res://Scenes/StandardGame.tscn"
	screenSize = get_viewport().size
	enemyX = screenSize.x - 40
	playerScore = 0
	enemyScore = 0
	placeScore()
	# Place both paddles 
	$Paddle.position = Vector2(playerX, screenSize.y / 2 - $Paddle.height / 2)
	$EnemyPaddle.position = Vector2(enemyX, screenSize.y / 2 - $EnemyPaddle.height / 2)


func _process(delta):
	#music
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	# If the ball goes off the screen behind the player
	if $Ball.position.x < 0:
		enemyScore += 1
		$Ball.resetBall()
		updateScore()
	# If the ball goes off the screen behind the enemy
	if $Ball.position.x > screenSize.x:
		playerScore += 1
		$Ball.resetBall()
		updateScore()
	# Make sure both paddles cannot be pushed by the ball
	if $Paddle.position.x != playerX: 
		$Paddle.position.x = playerX
	if $EnemyPaddle.position.x != enemyX:
		$EnemyPaddle.position.x = enemyX
	# Check for a win or loss
	checkGameScore()


func placeScore():
	# Place score texts at proper locations on screen
	$PlayerScore.text = str(playerScore)
	$EnemyScore.text = str(enemyScore)
	$PlayerScore.margin_top = 10
	$PlayerScore.margin_bottom = 17
	$PlayerScore.margin_left = screenSize.x / 4 - 20
	$PlayerScore.margin_right = screenSize.x / 4 + 20
	$EnemyScore.margin_top = 10
	$EnemyScore.margin_bottom = 17
	$EnemyScore.margin_left = 3 * screenSize.x / 4 - 20
	$EnemyScore.margin_right = 3 * screenSize.x / 4 + 20


func updateScore():
	# Convert score numbers to text on screen
	$PlayerScore.text = str(playerScore)
	$EnemyScore.text = str(enemyScore)


func checkGameScore():
	# Trigger a win or gameover based on the score
	if enemyScore >= SCORE_TO_WIN:
		# going to change to switch over to another dialogue scene.
		# ---------- Bryant made a change here ---------
		get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")
	elif playerScore >= SCORE_TO_WIN:
		if Global.choseLevel:
			get_tree().change_scene("res://Scenes/LevelSelectScreen.tscn")
		else: 
			Global.state = "won"
			get_tree().change_scene("res://Scenes/DialogueScene.tscn")
