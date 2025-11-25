extends PanelContainer

signal dialog_ended

@onready var content_label: RichTextLabel = %ContentLabel
@onready var avatar: TextureRect = %Avatar
@onready var finish_icon: TextureRect = %FinishIcon

var content
var tokens
var index = 0


func show_dialog_content_entry(entry: DialogContentEntry):
	index = 0
	
	content = entry.content
	content_label.clear()
	
	if entry.avatar:
		avatar.texture = entry.avatar
		avatar.visible = true
	else:
		avatar.visible = false
	finish_icon.visible = false
	
	tokenize()
	play_content()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if visible and finish_icon.visible:
			dialog_ended.emit()


func tokenize():
	tokens = []
	var index = 0
	
	while index < content.length():
		var character = content[index]
		if character == "\\":
			if content[index + 1] == ".":
				tokens.append({ type = "wait" })
				index = index + 2
			elif content[index + 1] == "[":
				tokens.append({ type = "keyword_start" })
				index = index + 2
			elif content[index + 1] == "]":
				tokens.append({ type = "keyword_end" })
				index = index + 2
			else:
				tokens.append({ type = "character", content = character })
				index = index + 1
		else:
			tokens.append({ type = "character", content = character })
			index = index + 1


func play_content():
	while index < tokens.size():
		var token = tokens[index]
		if token["type"] == "character":
			content_label.append_text(token["content"])
			if not Input.is_action_pressed("skip_dialog"):
				await get_tree().create_timer(0.03).timeout
		if token["type"] == "wait":
			if not Input.is_action_pressed("skip_dialog"):
				await get_tree().create_timer(0.25).timeout
		if token["type"] == "keyword_start":
			content_label.push_color(Color.YELLOW)
		if token["type"] == "keyword_end":
			content_label.pop()
		index = index + 1
	finish_icon.visible = true
