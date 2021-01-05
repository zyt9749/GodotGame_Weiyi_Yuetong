extends KinematicBody2D

export(NodePath) var dialogue_ui



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact_with_player(player):
	set_physics_process(false)
	$DialoguePlayer.dialogue_scence = "dialogue_1"
	get_node(dialogue_ui).show_dialogue(player, $DialoguePlayer, self, $Sprite.texture)
	
func touch_pigs(player):
	$DialoguePlayer.dialogue_scence = "with_pig"
	get_node(dialogue_ui).show_dialogue(player, $DialoguePlayer, self, $Sprite.texture)
