extends Node2D


func _ready():
  var kitty = G.ActorBuilder.create_kitty()
  kitty.position = Vector2(50, 50)
  add_child(kitty)
  var camera = Camera2D.new()
  kitty.add_child(camera)
  camera.make_current()

  var wolf = G.ActorBuilder.create_wolf()
  wolf.position = Vector2(60, 60)
  add_child(wolf)

