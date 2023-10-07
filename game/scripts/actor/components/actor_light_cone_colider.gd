extends "res://scripts/actor/actor_component.gd"

var length = 32
var width = 16

## list of layers the body shall be in
var collision_layer : Array[int] = []

## list of masks the body shall interact with
var collision_mask : Array[int] = []

var _body : CharacterBody2D = null

func _ready():
  _body = _build_kinematic_body()
  actor.add_child(_body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _build_kinematic_body() -> CharacterBody2D:
  var body = CharacterBody2D.new()
  var collision_shape = _build_collision_shape()

  body.add_child(collision_shape)
  body.collision_layer = _get_bits_combined(collision_layer)
  body.collision_mask = _get_bits_combined(collision_mask)

  return body
  
func _build_collision_shape() -> CollisionShape2D:
  var collision_shape = CollisionShape2D.new()
#  var rect_shape = RectangleShape2D.new()
  var shape = ConvexPolygonShape2D.new()
  shape.set_point_cloud(PackedVector2Array(
    [Vector2(0, 0),
     Vector2(length, width/2),
     Vector2(0, -width),
     Vector2(-length, width/2)]
    ))

  collision_shape.shape = shape
  return collision_shape


func _get_bits_combined(list: Array[int]) -> int:
  var bits := 0
  for entry in list:
    bits += int(pow(entry, 2))

  return bits
