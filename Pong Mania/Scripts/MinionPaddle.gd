extends RigidBody2D


export var width = 10
export var height = 40
var ball = null


# Called when the node enters the scene tree for the first time.
func _ready():
	ball = get_parent().find_node("Ball")
	$ColorRect.rect_size = Vector2(width, height)
	$CollisionShape2D.shape.extents = Vector2(width / 2, height / 2)

