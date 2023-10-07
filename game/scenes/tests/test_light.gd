extends Node2D


var kitty = null


func _ready():
  kitty = G.ActorBuilder.create_kitty()
  kitty.position = Vector2(50, 50)
  add_child.call_deferred(kitty)
  var camera = Camera2D.new()
  kitty.add_child.call_deferred(camera)
  camera.make_current.call_deferred()

  var wolf = G.ActorBuilder.create_wolf()
  wolf.position = Vector2(100, 100)
  add_child(wolf)
