# My tileMap Game [(Only 1% can get to Level 10!!)](https://legoguy32109.itch.io/only-1-can-make-it-to-level-10) Documentation

Final Project for 2D game development from Andy Harris *(Inspired by mobile game ads)*
* * *
![Level 2 screenshot](ScreenShots/Lv2.jpg)
![Level 9 screenshot](ScreenShots/Lv9.jpg)

## User Instructions

To play my game, just click the **[bold link here](https://legoguy32109.itch.io/only-1-can-make-it-to-level-10)** or up in the title to reach the itch.io page. You can run it in your browser and you move the player with WASD or the arrow keys ➡⬅⬆⬇. Unfortunately it is not mobile friendly, you will need a computer with a keyboard and an internet connection.

The game is made in [Godot](https://godotengine.org/), an amazing game engine that makes game design fun. Using nodes I was quickly able to prototype game mechanics, then hone them through GDscript. I was drawn to use Godot beacuse of their interesting tileMap editor. I was getting exhausted manually inputting coordinates to design levels. With some interesting advice from [PlayWithFurcifer](https://www.youtube.com/watch?v=5mGa2m_qCPQ) I discovered how to use scenes for tileMaps!

### TileMap innovation [found in this video](https://www.youtube.com/watch?v=5mGa2m_qCPQ)

What that last part meant, was initially the biggest limitation for tile maps is that you can draw reigons for Collisons, light Occlusions, or a connected Nav mesh for path finding. These features are fine for the walls that only need collision areas, but I needed player interacts to happen when I walked over these tiles...
![image of tileSet editor, it has limited functionality](ScreenShots/tileSetEditor.jpg)

This behavior can be encapsultaed in a scene, which is the Godot answer to Unity prefabs. A simple area that modulates itself to be greener when the player walks over it. It also store the state that it's activated so it won't be activated again, as without that the sound effect would constantly play as the character moved over them.

The soultion, render a dummy tile in the tileMap that are individually replaced by the scene as the level loads. [Here](Game.gd#L22) I go through each cell in the tileMap, identify if it's the dummy and should be replaced, then make an instance of the proper tile from the scene and add it to the same position of the current dummy.

```GDscript
# in Game.gd ...

for cellpos in tilemap.get_used_cells():
    var cell = tilemap.get_cellv(cellpos)
    # if the cell is labeled 0, it's the spot tiles and we want to replace 
    if cell == 0:
        # generate an instance of the tile place it at tileMap position
        var tile = spot.instance()
        tile.position = tilemap.map_to_world(cellpos) * tilemap.scale
        $Spots.add_child(tile)
        tilemap.set_cellv(cellpos, -1) # hide placeholder tile
```

I had to be careful to not do this before all the nodes were loaded, or I could be referencing a tilemap that doesn't exist. I discuss the design I implemented to fix this later in the documenation.

## Game Design Document

## Software Engineering Plan

|file suffix|file type description|
|:-:|-|
|.gd | GDscript file, lines of code that are tied to specific nodes in the project|
|.tscn| Scene file, a heirarchy of nodes that themselves could be sub scenes. A default scene file must be assigned in a Godot project to be the one rendered on startup|
|.png| image, in this case used for Sprites |
|.ogg | sound file, in this case for sound effects in game |
|.ttf | font data file |

### Structure of the project

- [Game.gd](Game.gd) - Game manager script
- [Player.gd](Player.gd) - Player movement script
- [Spot.gd](Spot.gd) - Level completing tiles affected by player
- [Tile.tscn](Tile.tscn) - Scene that replaces placeholder tiles
- [LevelConstants.tscn](LevelConstants.tscn) - Group of nodes necessary for every level
- [Player.tscn](Player.tscn) - Simple scene for player movement and control
- Levels - Directory of levels in game
  - [Level1.tscn](Levels/Level1.tscn) - Default scene for this project, starts here
  - [Level2.tscn](Levels/Level2.tscn)
  - ...
  - [Level11.tscn](Levels/Level11.tscn)
- Assets
  - [player.png](Assets/player.png) - Player Sprite image
  - [wall.png](Assets/wall.png) - Wall Sprite image
  - [tile.png](Assets/tile.png) - Unactivated Tile Sprite image, when activated modulates to green
  - [tileFlip.ogg](Assets/tileFlip.ogg) - Sound effect for tile activation
  - [yoster-island.regular.ttf](Assets/yoster-island.regular.ttf) - Font data for custom font
- [Exports](./Exports/) - Directory for project builds to HTML5 (**must** contain index.html)
  
## State Transition Diagram
