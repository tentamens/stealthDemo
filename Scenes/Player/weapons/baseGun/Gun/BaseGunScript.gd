extends Node

@onready var gunFireRayCast: RayCast3D = $Fire
@export var Damage:int = 10

func _unhandled_input(event):
	if Input.is_action_just_released("fire"):
		fire()
	

func fire():
	
	if !gunFireRayCast.is_colliding():
		return
	
	if !gunFireRayCast.get_collider().is_in_group("Enemy"):
		return
	
	
	
	gunFireRayCast.get_collider().hit(Damage)
	
