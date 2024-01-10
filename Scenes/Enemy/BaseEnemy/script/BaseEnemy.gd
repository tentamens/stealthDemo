class_name Enemy
extends CharacterBody3D

@onready var navAgent: NavigationAgent3D = $NavigationAgent3D
@export var health = 20
@export var alertArea: Node
@export var nearbyNavPointCollision: Node
@export var animationPlayer: AnimationPlayer
@export var SPEED:float = 3


var nearbyNavPoints = []
var previusNavTarget
var isPotrolling = true
var isTraveling = false
var isFighting = false


func _ready():
	navAgent.path_desired_distance = 0.5
	navAgent.target_desired_distance = 0.5
	await get_tree().create_timer(1).timeout
	call_deferred("actorSetup")


func actorSetup():
	await get_tree().physics_frame
	
	setMovementTarget()
	


func setMovementTarget():
	if !isPotrolling or isTraveling:
		return
	
	var newNavTarget = nearbyNavPoints.pick_random()
	
	if newNavTarget.isUsed == true:
		return
	
	if previusNavTarget != null:
		previusNavTarget.isUsed = false
	
	navAgent.target_position = newNavTarget.global_position
	newNavTarget.isUsed = true
	previusNavTarget = newNavTarget
	isTraveling = true
	

func _physics_process(delta):
	updateAnimation()
	if navAgent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navAgent.get_next_path_position()
	look_at(next_path_position)
	

	velocity = current_agent_position.direction_to(next_path_position) * SPEED
	move_and_slide()
	navAgent.set_velocity_forced(velocity)


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


func getHit(damage):
	
	health -= damage
	$SubViewport/HPbar.value = health
	if health <= 0:
		queue_free()
	alertArea.gotHit()




func newAlert(alertness):
	alertArea.newAlert(alertness)

func newMovementTarget(newPosition):
	navAgent.target_position = newPosition
	isPotrolling = false
	

func newNavPoint(area):
	if nearbyNavPointCollision.name == area.name:
		return
	nearbyNavPoints.append(area)


func _on_navigation_agent_3d_navigation_finished():
	print("stopped")
	isTraveling = false


func enterCombat():
	pass


func updateAnimation():
	if isPotrolling and isTraveling and animationPlayer.current_animation != "normalWalk": animationPlayer.play("normalWalk")
	if isPotrolling and !isTraveling and animationPlayer.current_animation != "normalIdle": animationPlayer.play("normalIdle")
	if !isPotrolling and isFighting and isTraveling and animationPlayer.current_animation != "combatWalk": animationPlayer.current_animation = "combatWalk"
	if !isPotrolling and isFighting and !isTraveling and animationPlayer.current_animation != "combatIdle": animationPlayer.current_animation = "combatIdle"
	







