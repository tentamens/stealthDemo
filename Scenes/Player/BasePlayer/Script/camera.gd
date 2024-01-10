extends Camera3D

@onready var camera = self
@onready var neck = get_parent()

var MOUSE_SENSITIVITY = 1

func _input(event):
	if event is InputEventMouseMotion:
		Crotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
		Crotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))

func Crotate_x(angle):
	camera.rotation_degrees.x += angle/-1
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func Crotate_y(angle):
	neck.rotation_degrees.y += angle
