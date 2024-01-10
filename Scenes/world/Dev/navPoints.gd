extends Node


func _ready():
	for i in get_children():
		updatePoints(i)
		

func updatePoints(name):
	for i in name.get_children():
		NavPositionUpdater.allPosition["MainDeck"].append(i.position)
