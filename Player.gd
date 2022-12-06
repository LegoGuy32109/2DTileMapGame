extends KinematicBody2D

onready var ray = $RayCast2D # raycast for collision detection
# the game is designed for a 16x16 pixel tiled grid, here is where I'd change that
var grid_size = 16
# if the player is moving, don't accept other inputs to try and change direction
var moving = false
# a dictionary keeping track of possible movements
var inputs = {
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT
}

# make sure all nodes are loaded before updating input or replacing tiles
var sceneReady = false
func _ready():
	sceneReady = true

# all inputs go here
func _unhandled_input(event):
	# don't allow movement changes if moving
	if sceneReady and !moving:
		for dir in inputs.keys():
			if event.is_action_pressed(dir):
				# find direction pressed then move in direction
				move(dir)
	# reset level if 'R' is pressed
	if event.is_action_pressed('reset'):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
			
# this recursively continues the movement in a certain position, it's an ice puzzle
func continue_move(vector_pos: Vector2):
	position += vector_pos
	# delay for animation, this is as fast as the player can go without skipping tiles as you ZOOM past
	yield(get_tree().create_timer(0.014), "timeout")
	# repeat movement until ray cast hits something
	ray.cast_to = vector_pos
	ray.force_raycast_update()
	if !ray.is_colliding():
		moving = true
		continue_move(vector_pos)
	else:
		moving = false
# this is the initial move of the player
func move(dir):
	# keep track of how many moves taken by referencing game object/script
	var game = get_parent()
	# calculate vector of direction from orientation and magnitude
	var vector_pos = inputs[dir] * grid_size
	ray.cast_to = vector_pos # create a raycast along vector
	ray.force_raycast_update() # update raycast to recieve collision info
	# if no collision detected, set recursive function to continue in that direction
	if !ray.is_colliding():
		# Increase movement counter by 1 if game isn't over
		if !get_parent().game_end:
			game.moves += 1
		continue_move(vector_pos)
