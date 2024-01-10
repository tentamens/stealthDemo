extends Node

var allPosition = {
	"MainDeck": []
}

func requestNewPosition(location, backUpPosition):
	if allPosition[location].size() == 0:
		print("backUp position has been used D:")
		return backUpPosition
	var newPosition = allPosition[location].pick_random()
	return newPosition
