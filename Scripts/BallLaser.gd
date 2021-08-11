extends KinematicBody2D

const RADIUS = 25
const COLOR = Color(1, 0.65, 0, 1)
const SPEED = 600
var velocity = Vector2(0.0, 0.0)
var moving = false
signal hit_player

func _ready():
	$CollisionShape2D.shape.radius = RADIUS


func _draw():
	draw_circle(Vector2(0,0), RADIUS, COLOR)


func setVelocity(x, y):
	# Normalize the vector to default it to a unit vector (a vector with a magnitude
	# of 1) to ensure it always travels at the speed specified by SPEED
	velocity = Vector2(x, y).normalized()
	# Once the velocity has been set, the laser can move
	moving = true


func _physics_process(delta):
	# The "moving" boolean is used to prevent the laser from moving until it's
	# velocity has been determined. 
	if moving:
		var collisionObject = move_and_collide(velocity * SPEED * delta)
		if collisionObject:
			velocity = velocity.bounce(collisionObject.normal)
			if "Paddle" in collisionObject.collider.name:
				emit_signal("hit_player")
				queue_free()
