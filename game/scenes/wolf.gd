extends Node2D


const WolfBuilder = preload("res://scripts/actor/wulf/wulf_builder.gd")


func _ready():
  $Sprite2D.queue_free()
  var wolf = WolfBuilder.create_wolf()
  wolf.position = Vector2(0,0)
  add_child(wolf)

