extends KinematicBody2D

onready var sprite = $AniPig
#onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var pigAnimPlayer = $PigAnimPlayer

export var WANDER_TARGET_RANGE = 4

export var ACCELERATION = 100
export var MAX_SPEED= 30
export var FRICTION = 200

export(NodePath) var dialogue_ui

enum {
	IDLE,
	WANDER,
	FLEET,
}

var keep_state = false
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var state = IDLE



func _ready():
	$AniPig.frame = 0
	
func _physics_process(delta):
	if keep_state == true:
		pass
	else:
		match state:
			IDLE:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
				seek_player()
				if wanderController.get_time_left() <= 0.1:
					update_wander()
					
			WANDER:
				seek_player()
				accelerate_towards_point(wanderController.target_position,delta)
				if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
					update_wander()
				sprite.flip_h = velocity.x > 0
				
			FLEET:
				var player = playerDetectionZone.player
				if player != null:
					pigAnimPlayer.play("Jump")
					accelerate_fleet_point(player.global_position,delta)
				else:
					state = WANDER
				sprite.flip_h = velocity.x > 0
			
		if softCollision.is_colliding():
			velocity +=softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)
	
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = FLEET
	
	
func accelerate_towards_point(point,_delta):
	direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * _delta)
	
func accelerate_fleet_point(point,_delta):
	pigAnimPlayer.play("Jump")
	keep_state = true
	direction = - global_position.direction_to(point)
	velocity = direction * 2 * MAX_SPEED
	yield(pigAnimPlayer, "animation_finished")
	keep_state = false
	
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))
	wanderController.update_target_position()
	
	
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func interact_with_player(player):
	set_physics_process(false)
	get_node(dialogue_ui).show_dialogue(player, $DialoguePlayer, self, $Sprite.texture)
	
	var missBlackWind = get_parent().get_parent().get_node("MissBlackWind")
	yield($DialoguePlayer, "dialogue_finished")
	missBlackWind.touch_pigs(player)
		
