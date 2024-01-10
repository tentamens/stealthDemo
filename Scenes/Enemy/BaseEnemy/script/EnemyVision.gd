extends Area3D

@export var raycastHolder: Node
@export var rayCastAmount: int = 5
@export var seeEnemyAlertNode: Node

var playerRef = null
var playerInVision = false

func updateVision():
	if playerRef == null or playerInVision == false: return
	
	raycastHolder.look_at(playerRef.global_position)
	checkRaycasts()


func checkRaycasts():
	var i = 0
	
	var hitThePlayer = false
	
	while i < rayCastAmount:
		i += 1
		var raycast: RayCast3D = get_node("raycasts/RayCast" + str(i))
		var playerHit = checkRaycastCollision(raycast)
		
		if playerHit:
			hitThePlayer = true
			break
	
	if !hitThePlayer:
		seeEnemyAlertNode.visible = false
		return
	
	seeEnemyAlertNode.visible = true
	


func checkRaycastCollision(raycast:RayCast3D):
	if !raycast.is_colliding(): return false
	if !raycast.get_collider() is Player: return false
	
	return true


func _on_body_entered(body):
	if body is Player:
		playerInVision = true


func _on_body_exited(body):
	if body is Player:
		playerInVision = false
		seeEnemyAlertNode.visible = false

