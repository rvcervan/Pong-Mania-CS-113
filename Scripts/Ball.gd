extends KinematicBody2D

export var initSpeed = 400
export var radius = 16
var screenSize
var speed
var velocity = Vector2(0.0, 0.0)
var lastHitObject = ""
const ACCEL = 1.02
signal hit_minion

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the screen dimensions
	screenSize = get_viewport_rect().size
	# Set the collision body of the ball
	$CollisionShape2D.shape.radius = radius
	resetBall()


func _draw():
	draw_circle(Vector2(0,0), radius, Color(1,1,1,1))
	

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
		#print(collisionObject.collider.name, " was hit")
		# Bounce along the normal of the angle of collision (perpendicular to the surface that was hit)
		velocity = velocity.bounce(collisionObject.normal)
		# Accelerate the ball. To prevent the issue where the ball sticks to a paddle and 
		# rapidly accelerates, the ball will only accelerate if it collides with a different
		# object than the one it most recently collided with
		if lastHitObject != collisionObject.collider.name:
			speed *= ACCEL
		# If the ball collides with a minion, erase the minion
		if "MinionPaddle" in collisionObject.collider.name:
			collisionObject.collider.queue_free()
			emit_signal("hit_minion")
		lastHitObject = collisionObject.collider.name
		
