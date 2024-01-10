extends Area3D

var alertness = 0
var nearbyUnits = []
var nearbyHideSpots = []

@export var BaseEnemy: Node
@export var enemyVisionNode: Node

func gotHit():
	alertness = 8
	for i in nearbyUnits.size():
		alert(i)
	getCover()


func alert(i):
	if !is_instance_valid(nearbyUnits[i]): return
	nearbyUnits[i].newAlert(alertness)
	pass


func newNearUnit(body):
	if body is Enemy:
		nearbyUnits.append(body)
		return
	
	if body is Player:
		enemyVisionNode.playerRef = body
		return
	


func newAlert(newAlertness):
	alertness = newAlertness
	alertnessUpdated()

# HIDE OUT SPOTS

func newNearbyHidespot(area):
	addNewHideSpot(area)

func addNewHideSpot(area):
	if area.name == name:
		return
	nearbyHideSpots.append(area)

func getCover():
	var closestHidingSpot
	for i in nearbyHideSpots:
		closestHidingSpot = checkHideSpot(closestHidingSpot, i)
	
	BaseEnemy.newMovementTarget(closestHidingSpot.global_position)
	BaseEnemy.isFighting = true
	BaseEnemy.isPotrolling = false


func checkHideSpot(closestHidingSpot, spot):
	
	if spot.isUsed == true:
		return closestHidingSpot
	if closestHidingSpot == null:
		return spot
	if global_position.distance_to(spot.global_position) < global_position.distance_to(closestHidingSpot.global_position):
		return spot
	
	return closestHidingSpot
	

# HANDLING NEW ALERT

func alertnessUpdated():
	
	if alertness > 7:
		getCover()

func runForCover():
	if BaseEnemy.isFighting == false:
		BaseEnemy.enterCombat()


