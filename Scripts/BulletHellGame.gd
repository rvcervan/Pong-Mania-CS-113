extends Node

const Laser = preload("res://Scenes/Laser.tscn")
const BallLaser = preload("res://Scenes/BallLaser.tscn")
const Ball = preload("res://Scenes/Ball.tscn")
const EnemyPaddle = preload("res://Scenes/EnemyPaddle.tscn")
const LaserAccel = 1.2
var screenSize    # Vector2 to hold screen dimensions
var playerX = 20
var playerScore
var enemyScore
var hitCount = 0
var laserSpawnX
var lowerLaserYBound
var upperLaserYBound
const LASER_WAIT_TIME = 0.20
var enemyX
# Variables for ball lasers and ball laser patterns
var ballLaserCount = 0
var ballLaserY
var ballLaserVelocity
var patternsFired
var functionArray = []
# Variables for third wave
var thirdWaveActive = false
var ball = null
var enemyPaddle = null

func _ready():
	Global.previousLevel = "res://Scenes/BulletHellGame.tscn"
	# Get screen dimensions
	screenSize = get_viewport().size
	enemyX = screenSize.x - 40
	# Place player paddle
	$Paddle.position = Vector2(playerX, screenSize.y / 2 - $Paddle.height / 2)
	# Initialize hit counter text
	$HitCounter.text = "Times hit: " + str(hitCount)
	# Set the bounds for spawning lasers
	setLaserBounds()
	# Set the laser timer's wait time
	$LaserTimer.wait_time = LASER_WAIT_TIME
	# Connect BallLaserShooter signals
	$BallLaserShooter1.connect("hit", self, "_on_Laser_hit_player")
	$BallLaserShooter2.connect("hit", self, "_on_Laser_hit_player")
	$BallLaserShooter3.connect("hit", self, "_on_Laser_hit_player")
	# Start the first wave
	startFirstWave()
	#startSecondWave()
	#ballPattern9()


func _process(delta):
	#music
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	if ball != null and enemyPaddle != null:
		if $Paddle.position.x != playerX: 
			$Paddle.position.x = playerX
		if enemyPaddle.position.x != enemyX:
			enemyPaddle.position.x = enemyX	
		if ball.position.x > screenSize.x:
			if Global.choseLevel:
				get_tree().change_scene("res://Scenes/LevelSelectScreen.tscn")
			else:
				Global.state = "won"
				get_tree().change_scene("res://Scenes/DialogueScene.tscn")
		if ball.position.x < 0:
			if len(functionArray) == 0:
				get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")
			else:
				freeBallAndPaddle()
				getBallPattern()


func startFirstWave():
	$FirstWaveTimer.start()
	$LaserTimer.start()


func startSecondWave():
	setFunctionArray()
	getBallPattern()
	
	
func startThirdWave():
	thirdWaveActive = true
	setFunctionArray()
	$PaddleSpawnTimer.start()


func setLaserBounds():
	laserSpawnX = screenSize.x - 40
	lowerLaserYBound = screenSize.y
	upperLaserYBound = 0


func _on_Laser_hit_player():
	hitCount += 1
	$HitCounter.text = "Times hit: " + str(hitCount)
	if hitCount >= 15:
		# ---------- Bryant made a change here ---------
		get_tree().change_scene("res://Scenes/TryAgainMenu.tscn")


func _on_LaserTimer_timeout():
	spawnLaser()
	$LaserTimer.start()


func spawnLaser():
	# Create a Laser instance
	var laser = Laser.instance()
	# Randomize the starting position of the laser
	laser.position = randomPosition()
	# Connect the laser's hit_player signal to _on_Laser_hit_player function
	laser.connect("hit_player", self, "_on_Laser_hit_player")
	add_child(laser)


func randomPosition():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return Vector2(laserSpawnX, rng.randi_range(upperLaserYBound, lowerLaserYBound))


func _on_FirstWaveTimer_timeout():
	$LaserTimer.stop()
	startSecondWave()


func _on_BallLaserShooter1_last_laser():
	$BallPatternTimer.start()


func ballPattern1():
	$BallLaserShooter2.fireLaserSet(15, screenSize.y / 2, Vector2(-1, 1.25))
	$BallLaserShooter1.fireLaserSet(6, screenSize.y / 2 + 250, Vector2(-1, 0), true, 1)
	
	
func ballPattern2():
	$BallLaserShooter1.fireLaserSet(10, screenSize.y / 2 + 200, Vector2(-1, -1))
	$BallLaserShooter2.fireLaserSet(10, screenSize.y / 2 - 200, Vector2(-1, 1))
	
	
func ballPattern3():
	$BallLaserShooter1.fireLaserSet(5, screenSize.y / 2, Vector2(-1, 0), false, 2)
	$BallLaserShooter2.fireLaserSet(20, screenSize.y / 2 + 250, Vector2(-1, 0), true, 0.5)
	
	
func ballPattern4():
	$BallLaserShooter1.fireLaserSet(10, screenSize.y / 2, Vector2(-1, -1.25))
	$BallLaserShooter2.fireLaserSet(10, screenSize.y - 50, Vector2(-1, -1.25))
	
	
func ballPattern5():
	$BallLaserShooter1.fireLaserSet(10, screenSize.y / 2, Vector2(-1, 1.25))
	$BallLaserShooter2.fireLaserSet(10, 50, Vector2(-1, 1.25))


func ballPattern6():
	$BallLaserShooter1.fireLaserSet(10, screenSize.y / 2, Vector2(-1, 0), true, 1)
	$BallLaserShooter2.fireLaserSet(20, screenSize.y / 2 + 200, Vector2(-1, 0), false, 0.5)
	$BallLaserShooter3.fireLaserSet(20, screenSize.y / 2 - 200, Vector2(-1, 0), false, 0.5)
	
	
func ballPattern7():
	$BallLaserShooter1.fireLaserSet(14, screenSize.y / 2, Vector2(-1, 0), false, 0.25)
	$BallLaserShooter2.fireLaserSet(7, screenSize.y / 2 + 100, Vector2(-1, 0.25), false, 0.5)
	$BallLaserShooter3.fireLaserSet(7, screenSize.y / 2 - 100, Vector2(-1, -0.25), false, 0.5)
	
	
func ballPattern8():
	$BallLaserShooter1.fireLaserSet(20, screenSize.y / 2, Vector2(-1, 0), true, 0.5)
	$BallLaserShooter2.fireLaserSet(10, screenSize.y / 2 + 200, Vector2(-1, 0), true, 1)
	$BallLaserShooter3.fireLaserSet(5, screenSize.y / 2 - 200, Vector2(-1, -1.5), false, 2)
	
	
func ballPattern9():
	$BallLaserShooter1.fireLaserSet(16, 25, Vector2(-1, 0), true, 1)
	$BallLaserShooter2.fireLaserSet(8, screenSize.y / 2 - 250, Vector2(-1, -1.5), false, 2)
	$BallLaserShooter3.fireLaserSet(12, screenSize.y / 2 + 250, Vector2(-1, 1.5), false, 1.33)


func setFunctionArray():
	functionArray = []
	for n in range(1, 10):
		functionArray.append(funcref(self, "ballPattern" + str(n)))
	randomize()
	functionArray.shuffle()


func getBallPattern():
	if len(functionArray) > 0:
		var f = functionArray.pop_back()
		f.call_func()
	else:
		startThirdWave()
		

func _on_BallPatternTimer_timeout():
	if not thirdWaveActive:
		getBallPattern()
	else:
		spawnBallAndPaddle()
	

func spawnBallAndPaddle():
	ball = Ball.instance()
	ball.position = Vector2(screenSize.x / 2, screenSize.y / 2)
	enemyPaddle = EnemyPaddle.instance()
	enemyPaddle.speed = 300
	enemyPaddle.position = Vector2(enemyX, screenSize.y / 2 - enemyPaddle.height / 2)
	add_child(ball)
	add_child(enemyPaddle)
	enemyPaddle.ball = ball
	

func freeBallAndPaddle():
	enemyPaddle.queue_free()
	enemyPaddle = null
	ball.queue_free()
	ball = null


func _on_PaddleSpawnTimer_timeout():
	spawnBallAndPaddle()
