extends Node

const BallLaser = preload("res://Scenes/BallLaser.tscn")
const STANDARD_RADIUS = 25
const STANDARD_WAIT = 0.2
var screenSize
var count = 0
var laserX
var laserY
var laserVel
var radius
var target
var wait
var player = null
signal hit
signal last_laser


# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport().size
	laserX = screenSize.x - 40
	player = get_parent().find_node("Paddle")


func fireLaserSet(n, y, v, t = false, s = STANDARD_WAIT):
	# n = number of lasers to fire
	# y = y-coordinate of laser spawn point
	# v = velocity (used for direction, not speed)
	# t = target player paddle (T/F)
	# s = wait time for firing lasers (Timer's wait time)
	count = n
	laserY = y
	laserVel = v
	target = t
	wait = s
	$Timer.wait_time = wait
	if count > 0:
		count -= 1
		fireLaser()


func fireLaser():
	var ballLaser = BallLaser.instance()
	ballLaser.connect("hit_player", self, "_on_laser_hit")
	ballLaser.position = Vector2(laserX, laserY)
	if player != null and target:
		ballLaser.setVelocity(player.position.x - laserX, player.position.y - laserY)
	else:
		ballLaser.setVelocity(laserVel.x, laserVel.y)
	add_child(ballLaser)
	$Timer.start()


func _on_laser_hit():
	emit_signal("hit")
	

func _on_Timer_timeout():
	if count > 0:
		count -= 1
		fireLaser()
		if count == 0:
			emit_signal("last_laser")
