extends Control


onready var dialog_name = $Container/DialoguePanel/HBoxContainer/VBoxContainer/Name
onready var content_text = $Container/DialoguePanel/HBoxContainer/VBoxContainer/Text
onready var next_button = $Container/DialoguePanel/HBoxContainer/Button
onready var textureRect = $Container/DialoguePanel/HBoxContainer/TextureRect
onready var tween = $Container/DialoguePanel/HBoxContainer/VBoxContainer/Tween

var dialogue_node = null
var dialogue_target = null

var txt_speed = 0.05
var can_next = false

func _ready():
	hide()
	textureRect.texture = null


func show_dialogue(player, dialogue, target, _texture):
	show()
	dialogue_target = target
	dialogue_node = dialogue
	for c in dialogue.get_signal_connection_list("dialogue_finished"):
		if self == c.target:
			dialogue_node.start_dialogue()
			break
			return
	get_tree().paused = true
	dialogue_node.connect("dialogue_finished", self, "hide")
	dialogue_node.connect("dialogue_finished", self, "_on_dialogue_finished", [player])
	dialogue_node.start_dialogue()
	textureRect.texture = _texture
	typewriter_dialogue()
	
	yield(get_tree().create_timer(1.0), "timeout")
	next_button.grab_focus()

func typewriter_dialogue():
	can_next = false
	dialog_name.text = dialogue_node.dialogue_name
	content_text.text = dialogue_node.dialogue_text
	var time = txt_speed * content_text.text.length()
	content_text.percent_visible = 0
	tween.interpolate_property(content_text, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	can_next = true

func _input(event):
	if Input.is_action_just_pressed("Dialogue") and self.visible == true:
		if can_next == true:
			dialogue_node.next_dialogue()
			typewriter_dialogue()
		else:
			content_text.percent_visible = 1
			tween.stop(content_text)
			can_next = true
			
#func _on_Button_button_up():
#	dialogue_node.next_dialogue()
#	typewriter_dialogue()

func _on_dialogue_finished(player):
	textureRect.texture = null
	get_tree().paused = false
	dialogue_node.disconnect("dialogue_finished", self, "hide")
	dialogue_node.disconnect("dialogue_finished", self, "_on_dialogue_finished")
