extends KinematicBody2D


export var ACCELERATION = 300
export var MAX_SPEED = 150
export var FRICTION = 3000


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
#onready var swordHitbox = $HitboxPivot/SwordHitbox
#onready var hurtbox = $Hurtbox
onready var popLog = $PopLog

enum{
	MOVE,
	IDLE
	RUN,
}


var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
#var stats = PlayerStats

func _ready():
	randomize()
#	stats.connect("no_health",self,"queue_free")
	animationTree.active = true
	
func _physics_process(delta):
	show_interaction_key()
	match state:
		MOVE:
			move_state(delta)
		RUN:
			pass
			
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity .move_toward(input_vector*MAX_SPEED , ACCELERATION * delta)
	else: 
		animationState.travel("Idle")
		velocity = velocity .move_toward(Vector2.ZERO , FRICTION * delta)
		
	move()
	
func move():
	velocity = move_and_slide(velocity)
	
func show_interaction_key():
	var interact = $InteractionDetectionZone
	if interact.can_interact():
		$PresseIcon.show()
		$InteractionAnimPlayer.play("Interaction")
		if Input.is_action_pressed("Interact"):
			interact.target.interact_with_player(self)
	else:
		$InteractionAnimPlayer.stop()
		$PresseIcon.hide()
