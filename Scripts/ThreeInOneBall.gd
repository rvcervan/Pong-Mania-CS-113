extends KinematicBody2D


export var initSpeed = 320
export var radius = 16
var screenSize
var speed
var velocity = Vector2(0.0, 0.0)
var lastHitObject = ""
const ACCEL = 1.02
var currentColor
const RED = Color(1, 0, 0, 1)
const GREEN = Color(0, 1, 0, 1)
const PURPLE = Color(0.63, 0.13, 0.94, 1)
signal collide

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	currentColor = RED
	resetBall()


func _draw():
	draw_circle(Vector2(0,0), radius, currentColor)
	

func resetBall():
	# Return the ball to the center of the screen and reset its speed
	speed = initSpeed
	position = Vector2(screenSize.x / 2, screenSize.y / 2)
	# Set the random seed and randomize the ball's direction
	randomize()
	velocity.x = [-1, 1][randi() % 2]
	velocity.y = [-0.8, 0.8][randi() % 2]
	lastHitObject = ""
	
	
func _physics_process(delta):
	# "delta" is defined as the number of frames between this call to _physics_process and
	# the most recent call. It is needed to keep the speed of the ball constant. "velocity"
	# defines the direction of the ball (it is a Vector2, not a number. "speed" is the 
	# actual speed of the ball.
	if abs(velocity.x) < 0.5:
		if velocity.x < 0:
			velocity.x = -0.7
		else:
			velocity.x = 0.7
	if abs(velocity.y) < 0.5:
		if velocity.y < 0:
			velocity.y = -0.7
		else:
			velocity.y = 0.7
	var collisionObject = move_and_collide(velocity * speed * delta)
	# If the ball collides with an object
	if collisionObject:
		# Bounce along the normal of the angle of collision (perpendicular to the surface that was hit)
		velocity = velocity.bounce(collisionObject.normal)
		# Accelerate the ball. To prevent the issue where the ball sticks to a paddle and 
		# rapidly accelerates, the ball will only accelerate if it collides with a different
		# object than the one it most recently collided with
		if lastHitObject != collisionObject.collider.name:
			speed *= ACCEL
		# If the ball collides with the paddle, emit a signal
		if ("ThreeInOnePaddle" in collisionObject.collider.name) and (lastHitObject != collisionObject.collider.name):
			emit_signal("collide")
		lastHitObject = collisionObject.collider.name
