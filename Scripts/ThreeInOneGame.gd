extends Node

var screenSize
var playerX = 20
var enemyX
var playerScore
var enemyScore
const SWITCH_CHANCE = 0.6
const SCORE_TO_WIN = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.previousLevel = "res://Scenes/ThreeInOneGame.tscn"
	screenSize = get_viewport().size
	enemyX = screenSize.x - 40
	playerScore = 0
	enemyScore = 0
	placeScore()
	# Place both paddles 
	$Paddle.position = Vector2(playerX, screenSize.y / 2 - $Paddle.height / 2)
	$ThreeInOnePaddle.position = Vector2(enemyX, screenSize.y / 2 - $ThreeInOnePaddle.height / 2)
	slowPlayer()
	

func _process(delta):
	#background music
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	# If the ball goes off the screen behind the player
	if $ThreeInOneBall.position.x < 0:
		enemyScore += 1
		$ThreeInOneBall.resetBall()
		updateScore()
	# If the ball goes off the screen behind the enemy
	if $ThreeInOneBall.position.x > screenSize.x:
		playerScore += 1
		$ThreeInOneBall.resetBall()
		updateScore()
	# Make sure both paddles cannot be pushed by the ball
	if $Paddle.position.x != playerX: 
		$Paddle.position.x = playerX
	if $ThreeInOnePaddle.position.x != enemyX:
		$ThreeInOnePaddle.position.x = enemyX
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


func _on_ThreeInOneBall_collide():
	if rand_range(0,1) <= SWITCH_CHANCE:
		var x = rand_range(0,1)
		if x <= 0.33:
			swapPlayerControls()
		elif x > 0.66:
			slowPlayer()
		else:
			shrinkPlayer()
		
		
func swapPlayerControls():
	$ThreeInOneBall.currentColor = $ThreeInOneBall.GREEN
	$ThreeInOneBall.update()
	$Paddle.resetSpeed()
	$Paddle.resetSize()
	$Paddle.swapped = true
	

func slowPlayer():
	$ThreeInOneBall.currentColor = $ThreeInOneBall.RED
	$ThreeInOneBall.update()
	$Paddle.resetSize()
	$Paddle.swapped = false
	$Paddle.setSpeed(280)
	
	
func shrinkPlayer():
	$ThreeInOneBall.currentColor = $ThreeInOneBall.PURPLE
	$ThreeInOneBall.update()
	$Paddle.resetSpeed()
	$Paddle.swapped = false
	$Paddle.setSize(50)
	

func checkGameScore():
	# Trigger a win or gameover based on the score
	if enemyScore >= SCORE_TO_WIN:
		# ---------- Bryant made a change here ---------
		get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")
	elif playerScore >= SCORE_TO_WIN:
		if Global.choseLevel:
			get_tree().change_scene("res://Scenes/LevelSelectScreen.tscn")
		else: 
			Global.state = "won"
			get_tree().change_scene("res://Scenes/DialogueScene.tscn")
