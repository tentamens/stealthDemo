extends Area3D

@onready var parent = $".."

func hit(damage):
	
	parent.getHit(damage)


func _on_alert_nearby_area_entered(area):
	pass # Replace with function body.
