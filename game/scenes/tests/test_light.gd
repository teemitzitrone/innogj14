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
    light.current_direction = _translate_vector_to_direction(kitty.direction)


# TODO: move to light script
# TODO: to make diagonal possible, check against x,y < or > 0
func _translate_vector_to_direction(v: Vector2) -> LightScript.Direction:
  match v:
    Vector2(0, -1):
      return LightScript.Direction.UP
    Vector2(1, -1):
      return LightScript.Direction.UP_RIGHT
    Vector2(1, 0):
      return LightScript.Direction.RIGHT
    Vector2(1, 1):
      return LightScript.Direction.DOWN_RIGHT
    Vector2(-1, 1):
      return LightScript.Direction.DOWN_LEFT
    Vector2(-1, 0):
      return LightScript.Direction.LEFT
    Vector2(-1, -1):
      return LightScript.Direction.UP_LEFT
    Vector2(0, 0), Vector2(0, 1), _:
      return LightScript.Direction.DOWN

