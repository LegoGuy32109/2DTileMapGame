extends Area2D

var active = false # true if player crosses over it

# when entity enters body, check if that entity is player
func _on_Spot_body_entered(body):
	if body.is_in_group('player') and !active:
		active = true # the tile is on, and doesn't need to be turned on again
		
		$AudioStreamPlayer.play() # play sticky sound effect
		
		modulate = Color(0.6, 1, 0.6) # set color to be greener

