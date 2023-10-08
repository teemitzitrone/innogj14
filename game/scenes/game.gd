extends Node2D

@onready var tile_map = $TileMap

func _ready():
  var kitty = G.ActorBuilder.create_kitty()
  kitty.position = Vector2(50, 50)
  add_child(kitty)
  var camera = Camera2D.new()
  kitty.add_child(camera)
  camera.make_current()
  tile_map.player = kitty
#  camera.zoom = Vector2(0.4, 0.4)
