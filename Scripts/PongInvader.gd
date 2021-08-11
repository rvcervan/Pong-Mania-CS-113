extends KinematicBody2D

export var width = 15
export var height = 60
const invaderLeftMovement = -1500
var speed = 100
var screenSize
var PongInvaders = []
var velocity = Vector2(0, 1)
var movingDown = true
signal invaderDied
signal allInvadersDied
signal invaderTouchedPaddle

# Called when the node enters the scene tree for the first time.
func _ready():
	# Note that this paddle expects a standard ball
	screenSize = get_viewport_rect().size
	PongInvaders.append(get_parent().find_node("PongInvader"))
	PongInvaders.append(get_parent().find_node("PongInvader2"))
	PongInvaders.append(get_parent().find_node("PongInvader3"))
	PongInvaders.append(get_parent().find_node("PongInvader4"))
	$ColorRect.rect_size = Vector2(width, height)
	$CollisionShape2D.shape.extents = Vector2(width / 2, height / 2)


func invadersReachedEndOfScreen():
	if movingDown:
		return PongInvaders[-1].position.y >= 430
	else:
		return PongInvaders[0].position.y <= 10


func switchInvaderYMovement():
	for invader in PongInvaders:
		invader.moveTowardsPlayer()
		invader.movingDown = not invader.movingDown
		invader.velocity = Vector2(0, 1) if invader.movingDown else Vector2(0, -1)
		
func removeInvaderFromList(invader):
	var allInvaders = PongInvaders.duplicate()
	for invdr in allInvaders:
		invdr.PongInvaders.erase(invader)
	
func moveTowardsPlayer():
	move_and_slide(Vector2(invaderLeftMovement, 0))


func _physics_process(delta):
	# Switch Y axis movement direction after an invader has reached the edge of the screen
	if invadersReachedEndOfScreen():
		switchInvaderYMovement()
	var collidedObject = move_and_collide(velocity * speed * delta)
	if collidedObject:
		if "Paddle" in collidedObject.collider.name:
			emit_signal("invaderTouchedPaddle")
		elif "Ball" in collidedObject.collider.name:
			removeInvaderFromList(self)
			emit_signal("invaderDied")
			if not PongInvaders:
				emit_signal("allInvadersDied")
			queue_free()

