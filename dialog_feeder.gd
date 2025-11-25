extends Node

@export var dialog_content: DialogContent
@export var dialog_container: Control

var index = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialog_container.show_dialog_content_entry(dialog_content.entries[0])
	dialog_container.dialog_ended.connect(show_next_entry)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func show_next_entry():
	if index < dialog_content.entries.size():
		dialog_container.show_dialog_content_entry(dialog_content.entries[index])
		index = index + 1
	else:
		dialog_container.hide()
