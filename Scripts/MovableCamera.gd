extends Camera2D

var dragging = false
var is_onto_console = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.zoom.x = 1
	self.zoom.y = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if is_onto_console == false:
		if Input.is_action_pressed("B_LEFT"):
			dragging = true
		else:
			dragging = false
		if Input.is_action_pressed("B_LEFT") and dragging:
			position = get_global_mouse_position()

		if  Input.is_action_just_pressed("S_UP"):
			if zoom.x + 1 > 6 and zoom.y + 1 > 6:
				self.zoom.x = 6
				self.zoom.y = 6
			else:
				self.zoom.x += 1
				self.zoom.y += 1
			if Input.is_action_just_released("S_UP"):
				position = get_global_mouse_position()
		elif Input.is_action_just_pressed("S_DOWN"):
			if zoom.x - 1 <= 0 and zoom.y - 1 <= 0:
				zoom.x = 1
				zoom.y = 1
			else:
				self.zoom.x -= 1
				self.zoom.y -= 1
