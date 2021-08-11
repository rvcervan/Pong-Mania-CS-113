extends Node

const MinionPaddle = preload("res://Scenes/MinionPaddle.tscn")
var screenSize    # Vector2 to hold screen dimensions
var playerX = 20
var enemyX        # x-coordinate of enemy paddle
var playerScore
var enemyScore
const MAX_MINIONS = 3
var lowerMinionXBound
var higherMinionXBound
var lowerMinionYBound
var higherMinionYBound
const SCORE_TO_WIN = 5 #was originaly 7 --Bryant made change

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get screen dimensions
	screenSize = get_viewport().size
	setMinionBounds()
	enemyX = screenSize.x - 40
	playerScore = 0
	enemyScore = 0
	placeScore()
	# Place both paddles 
	$Paddle.position = Vector2(playerX, screenSize.y / 2 - $Paddle.height / 2)
	$EnemyPaddle.position = Vector2(enemyX, screenSize.y / 2 - $EnemyPaddle.height / 2)
	#$EnemyPaddle.speed = 320
	$MinionTimer.start()

func _process(delta):
	Global.previousLevel = "res://Scenes/MinionGame.tscn"
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


func setMinionBounds():
	lowerMinionXBound = screenSize.x / 2 + 10
	higherMinionXBound = screenSize.x - 80
	lowerMinionYBound = screenSize.y - 80
	higherMinionYBound = 40


func randomPosition():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return Vector2(rng.randi_range(lowerMinionXBound, higherMinionXBound), rng.randi_range(higherMinionYBound, lowerMinionYBound))


func firstMinionWave():
	for i in range(3):
		var minion = MinionPaddle.instance()
		add_child(minion)
		minion.position = Vector2(screenSize.x / 2 + 100, screenSize.y / 2 - $EnemyPaddle.height / 2 - 120 + (i * 120))
		
	
	
func secondMinionWave():
	for i in range(3):
		var minion = MinionPaddle.instance()
		add_child(minion)
		minion.position = Vector2(screenSize.x / 2 - 100, screenSize.y / 2 - $EnemyPaddle.height / 2 - 120 + (i * 120))
		
		
func callMinion():
	# Get all minions that are in play
	var minions = get_tree().get_nodes_in_group("minions")
	# Create a instance of a minion
	var minion = MinionPaddle.instance()
	while true:
		# Generate a random point for the minion to spawn in
		minion.position = randomPosition()
		# If the minion's current position obstructs any existing minions, choose a different position
		for m in minions:
			if minionsObstruct(minion, m):
				continue
		# Add the minion to the game
		add_child(minion)
		return


func minionsObstruct(m1, m2):
	if m1.position.x < m2.position.x - m2.width or m1.position.x > m2.position.y + m2.width:
		return true
	if m1.position.y < m2.position.y - m2.height or m1.position.y > m2.position.y + m2.height:
		return true
	return false


func _on_MinionTimer_timeout():
	callMinion()
	# Restart the minion timer if the max amount has not been reached
	if get_tree().get_nodes_in_group("minions").size() < MAX_MINIONS:
		$MinionTimer.start()


func _on_Ball_hit_minion():
	# Start the minion timer if there are no longer the max number of minions on the field
	if get_tree().get_nodes_in_group("minions").size() == MAX_MINIONS - 1:
		$MinionTimer.start()
		
		
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
