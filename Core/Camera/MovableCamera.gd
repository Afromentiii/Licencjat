extends Camera2D

var dragging = false
var is_onto_console = false

# Ustawienia kamery
var zoom_min = 0.2  # Jak bardzo można oddalić (0.2 to widok z daleka)
var zoom_max = 10.0 # Jak bardzo można przybliżyć (10x zoom)
var zoom_step = 0.2 # Płynność - o ile zmienia się zoom przy jednym ticku scrolla

func _ready():
	self.zoom = Vector2(1, 1)

func _process(_delta):
	if is_onto_console == false:
		
		# Obsługa przeciągania
		if Input.is_action_pressed("B_LEFT"):
			dragging = true
			position = get_global_mouse_position()
		else:
			dragging = false

		# Obsługa Zoom In (S_UP)
		if Input.is_action_just_pressed("S_UP"):
			var new_zoom = zoom.x + zoom_step
			# clamp() pilnuje, żeby new_zoom nie było mniejsze niż zoom_min i większe niż zoom_max
			new_zoom = clamp(new_zoom, zoom_min, zoom_max) 
			zoom = Vector2(new_zoom, new_zoom)
			
			if Input.is_action_just_released("S_UP"):
				position = get_global_mouse_position()
				
		# Obsługa Zoom Out (S_DOWN)
		elif Input.is_action_just_pressed("S_DOWN"):
			var new_zoom = zoom.x - zoom_step
			new_zoom = clamp(new_zoom, zoom_min, zoom_max)
			zoom = Vector2(new_zoom, new_zoom)
