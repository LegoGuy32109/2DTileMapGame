extends Node2D

var game_end = false
var moves = 0

# find the resource to the next level
onready var nextLevel = "res://Levels/Level"+str(int(get_parent().name.trim_prefix("Level"))+1)+".tscn"

onready var tilemap = get_parent().get_child(0)
# this is the spot scene we will replace the placeholder tiles with
const spot = preload("res://Tile.tscn")

func _ready():
	# I check to make sure the nodes exist before editing them
	if $NameLabel:
		# display the current level based on the name of the scene node
		$NameLabel.text = "Level "+str(get_parent().name.trim_prefix("Level"))
	if tilemap:
		for cellpos in tilemap.get_used_cells():
			var cell = tilemap.get_cellv(cellpos)
			# if the cell is labeled 0, it's the spot tiles and we want to replace 
			if cell == 0:
				# generate an instance of the tile place it at tileMap position
				var tile = spot.instance()
				tile.position = tilemap.map_to_world(cellpos) * tilemap.scale
				$Spots.add_child(tile)
				tilemap.set_cellv(cellpos, -1) # hide placeholder tile

# warning-ignore:unused_argument
func _process(delta):
	# making sure tiles exist that the player can run over
	if $Spots and $Spots.get_child_count() > 0:
		# indicate the moves the player made
		if moves:
			$MovesLabel.text = 'Moves: ' + str(moves)
		if $Spots and !game_end:
			# check if any spots are active, if they all are game over
			var spots = $Spots.get_child_count()
			for i in $Spots.get_children():
				if i.active:
					spots -= 1
			
			if spots == 0:
				# an accept dialog was the quickest way I could think of for an end level menu, you can still restart the level if you want to try for lower moves 
				$AcceptDialog.popup()
				game_end = true

# when the accept dialog returns switch to next level
func _on_AcceptDialog_confirmed():
	print("changing to "+nextLevel)
	# if file doesn't exist, go to first level and loop
	var file2Check = File.new()
	if(file2Check.file_exists(nextLevel)):
# warning-ignore:return_value_discarded
		get_tree().change_scene(nextLevel)
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Levels/Level1.tscn")		
