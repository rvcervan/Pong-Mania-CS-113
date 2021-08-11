extends KinematicBody2D

var initSpeed = 400
var screenSize
var speed
signal hit_player

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	speed = initSpeed

func _physics_process(delta):
	var collisionObject = move_and_collide(Vector2(-speed * delta, 0))
	if (collisionObject):
		#collisionObject.get_collider().queue_free()
		#^ Removes the player paddle lmao. Increment a counter instead.
		if "Paddle" in collisionObject.collider.name:
			emit_signal("hit_player")
		queue_free()
