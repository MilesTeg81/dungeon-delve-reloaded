extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 1 # Change this to increase it to more units/second
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Moves to Vector(0,0) at a speed of 1 unit per second
	#$".".rect_position.y = position.move_toward(Vector2(0,0), delta * speed)
	pass
