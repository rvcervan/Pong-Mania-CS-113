extends Node

const Laser = preload("res://Scenes/Laser.tscn")
const LaserAccel = 1.2
var screenSize    # Vector2 to hold screen dimensions
var playerX = 20
var playerScore
var enemyScore
var hitCount = 0
var laserSpawnX
var lowerLaserYBound
var upperLaserYBound
var enemyX
var allInvadersDied = false
const SCORE_TO_WIN = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.previousLevel = "res://Scenes/SpaceInvaderGame.tscn"
	# Get screen dimensions
	screenSize = get_viewport().size
	enemyX = screenSize.x - 40
	setLaserBounds()
	playerScore = 0
	enemyScore = 0
	$HitCounter.text = "Times hit: " + str(hitCount)
	# Place both paddles 
	$Paddle.position = Vector2(playerX, screenSize.y / 2 - $Paddle.height / 2)
	get_tree().paused = true
	get_tree().paused = false
	$LaserTimer.start()


func setLaserBounds():
	laserSpawnX = screenSize.x - 40
	lowerLaserYBound = screenSize.y
	upperLaserYBound = 0

func _process(delta):
	#music
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	# Make sure both paddles cannot be pushed by the ball
	if $Paddle.position.x != playerX: 
		$Paddle.position.x = playerX
	if allInvadersDied:
		if $EnemyPaddle.position.x != enemyX:
			$EnemyPaddle.position.x = enemyX
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
		checkGameScore()
	else:
		if $Ball.position.x < 0 or $Ball.position.x > screenSize.x:
			$Ball.resetBall()


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
	

func updateHitCounter():
	hitCount += 1
	#if hitCount > 1:
		# Game Over!
		# End game here
	$HitCounter.text = "Times hit: " + str(hitCount)
	if hitCount >= 8:
		get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")


func randomPosition():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return Vector2(laserSpawnX, rng.randi_range(upperLaserYBound, lowerLaserYBound))


func _on_LaserTimer_timeout():
	var laser = Laser.instance()
	laser.position = randomPosition()
	laser.connect("hit_player", self, "_on_Laser_hit_player")
	# Set laser collision and layer mask to only 2 in order to avoid collision with ball and PongInvaders (https://godotengine.org/qa/28514/how-to-use-set_collision_layer_bit-or-mask).
	laser.set_collision_layer_bit(0, false)
	laser.set_collision_mask_bit(0, false)
	laser.set_collision_layer_bit(1, true)
	laser.set_collision_mask_bit(1, true)
	add_child(laser)
	$LaserTimer.start()


func _on_Laser_hit_player():
	updateHitCounter()


func _on_PongInvader_invaderDied():
	$LaserTimer.wait_time /= LaserAccel


func _on_PongInvader2_invaderDied():
	$LaserTimer.wait_time /= LaserAccel


func _on_PongInvader3_invaderDied():
	$LaserTimer.wait_time /= LaserAccel


func _on_PongInvader4_invaderDied():
	$LaserTimer.wait_time /= LaserAccel


func startEnemyPaddleStage():
	$EnemyPaddle.position = Vector2(enemyX, screenSize.y / 2 - $EnemyPaddle.height / 2)
	allInvadersDied = true
	placeScore()
	$Ball.resetBall()

func _on_PongInvader_allInvadersDied():
	startEnemyPaddleStage()


func _on_PongInvader2_allInvadersDied():
	startEnemyPaddleStage()


func _on_PongInvader3_allInvadersDied():
	startEnemyPaddleStage()


func _on_PongInvader4_allInvadersDied():
	startEnemyPaddleStage()


func _on_PongInvader_invaderTouchedPaddle():
	# not sure if this was for the player or the laser? --Bryant
	# if this is relevant to when player loses, change scene to
	# --> "res://TryAgainMenu.tscn" same goes for below
	#get_tree().change_scene("res://Scenes/Gameover.tscn")
	get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")


func _on_PongInvader2_invaderTouchedPaddle():
	# not sure if this was for the player or the laser? --Bryant
	#get_tree().change_scene("res://Scenes/Gameover.tscn")
	get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")


func _on_PongInvader3_invaderTouchedPaddle():
	# not sure if this was for the player or the laser? --Bryant
	#get_tree().change_scene("res://Scenes/Gameover.tscn")
	get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")


func _on_PongInvader4_invaderTouchedPaddle():
	# not sure if this was for the player or the laser? --Bryant
	#get_tree().change_scene("res://Scenes/Gameover.tscn")
	get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")
	
	
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
