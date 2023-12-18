extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
# Initially, the label is hidden
	visible = true

func show_label():
# Show the label when the condition is met
	visible = true

func hide_label():
# Hide the label when the condition is no longer met
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
