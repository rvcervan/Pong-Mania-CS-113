extends KinematicBody2D

const DEFAULT_WIDTH = 20
const DEFAULT_HEIGHT = 80
const DEFAULT_SPEED = 400
export var width = 20  # Paddle width
export var height = 80 # Paddle height
var speed = 400        # Paddle speed
var swapped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the visual size of the paddle
	$ColorRect.rect_size = Vector2(width, height)
	# Set the collision shape of the paddle
	$CollisionShape2D.shape.extents = Vector2(width / 2, height / 2)


func setSize(newHeight):
	height = newHeight
	$ColorRect.rect_size = Vector2(width, height)
	$CollisionShape2D.shape.extents = Vector2(width / 2, height / 2)
	$CollisionShape2D.position = Vector2(5, 20)
	update()
	
	
func resetSize():
	height = DEFAULT_HEIGHT
	$ColorRect.rect_size = Vector2(width, height)
	$CollisionShape2D.shape.extents = Vector2(width / 2, height / 2)
	$CollisionShape2D.position = Vector2(10, 40)
	update()
	

func setSpeed(newSpeed):
	speed = newSpeed


func resetSpeed():
	speed = DEFAULT_SPEED
	

func _physics_process(delta):
	# Use a Vector2 to define the paddle's movement direction
	var velocity = Vector2(0.0, 0.0)
	# Set the y-velocity of the paddle based on the player's input (up and
	# down arrows)
	if not swapped:
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1	
	else:
		if Input.is_action_pressed("ui_up"):
			velocity.y += 1
		if Input.is_action_pressed("ui_down"):
			velocity.y -= 1	
	# Move the paddle using both the velocity and actual speed of the paddle
	move_and_slide(velocity * speed)
