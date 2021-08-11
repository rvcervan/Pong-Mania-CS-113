extends KinematicBody2D

export var width = 20
export var height = 80
var speed = 200
var ball = null
const ERROR_RANGE = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	ball = get_parent().find_node("ThreeInOneBall")
	$ColorRect.rect_size = Vector2(width, height)
	$CollisionShape2D.shape.extents = Vector2(width / 2, height / 2)


func _physics_process(delta):
	var velocity = Vector2(0,0)
	# If the absolute value of the y-distance between the ball and the center
	# of the paddle is significant enough...
	if ball != null and abs(ball.position.y - (position.y + height / 2)) > ERROR_RANGE:
		# Change the paddle's velocity based on whether the ball is above or
		# below the center of the paddle
		if ball.position.y > (position.y + height / 2): velocity.y += 1
		else: velocity.y -= 1
	move_and_slide(velocity * speed)
