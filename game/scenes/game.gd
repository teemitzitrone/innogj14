extends Node2D


func _ready():
  var kitty = G.ActorBuilder.create_kitty()
  kitty.position = Vector2(50, 50)
  add_child(kitty)

