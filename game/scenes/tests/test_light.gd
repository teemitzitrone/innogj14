extends Node2D


const LightScript = preload("res://scenes/objects/light/light.gd")
const Light = preload("res://scenes/objects/light/light.tscn")

var kitty = null
var light = null


func _ready():
  kitty = G.ActorBuilder.create_kitty()
  kitty.position = Vector2(50, 50)
  add_child.call_deferred(kitty)
  var camera = Camera2D.new()
  kitty.add_child.call_deferred(camera)
  camera.make_current.call_deferred()
  light = Light.instantiate()
  kitty.add_child(light)

  kitty.direction_changed.connect(_on_actor_direction_changed)
  kitty.velocity_changed.connect(_on_actor_direction_changed)


func _on_actor_direction_changed():
  if light == null:
    return

  if kitty.velocity == Vector2.ZERO:
    light.current_direction = LightScript.Direction.DOWN
  else:
    light.set_direction_vector(kitty.direction)

