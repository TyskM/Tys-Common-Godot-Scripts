
# IN THE INPUT MAP, SET INPUTS FOR:
# CAMERA_ZOOMIN
# CAMERA_ZOOMOUT
# CAMERA_DRAG

extends Camera2D

export var zoom_increment = Vector2(1, 1) # How fast the camera zooms in/out
export var zoom_max = Vector2(0.5, 0.5) # Caps the amount you can zoom in
export var zoom_min = Vector2(6, 6) # Caps the amount you can zoom out
export var inverted = false # Inverts the dragging direction for wierd people
export var drag_zoom_scaling = true # Makes dragging less sensitive as camera zoom increases

var following = false
var dragging = false
var zoom_average = 1
    
func _input(event):
    dragHandler(event)
    zoomHandler(event)
    
func reset_zoom():
    print('Resetting zoom...')
    self.zoom = (zoom_min + zoom_max) / 2
    
func zoom(increment):
    if self.zoom + increment > zoom_max and self.zoom + increment < zoom_min:
        self.zoom += increment
    if self.zoom < zoom_max or self.zoom > zoom_min:
        reset_zoom()

func zoomHandler(event):
    if Input.is_action_just_pressed("CAMERA_ZOOMIN"):
        zoom(-zoom_increment)
    if Input.is_action_just_pressed("CAMERA_ZOOMOUT"):
        zoom(zoom_increment)

func dragHandler(event):
    if drag_zoom_scaling:
        zoom_average = (self.zoom.x + self.zoom.y) / 2
    else:
        zoom_average = 1
    
    # Determines if CAMERA_DRAG is pressed 
    if Input.is_action_just_pressed("CAMERA_DRAG"):
        dragging = true
    if Input.is_action_just_released("CAMERA_DRAG"):
        dragging = false
    
    # Moves the camera if dragging is true
    if event is InputEventMouseMotion and dragging:
        if inverted:
            self.position += event.relative * zoom_average
        else:
            self.position -= event.relative * zoom_average
            
