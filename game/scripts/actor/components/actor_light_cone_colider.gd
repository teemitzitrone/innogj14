extends "res://scripts/actor/actor_component.gd"

var length = 32
var width = 16

## list of layers the body shall be in
var collision_layer : Array[int] = []

## list of masks the body shall interact with
var collision_mask : Array[int] = []

var _body : CharacterBody2D = null

func ready() -> void:
  _body = _build_kinematic_body()
  actor.add_child(_body)
  actor.direction_changed.connect(onDirectionChange)

func _build_kinematic_body() -> CharacterBody2D:
  var body = CharacterBody2D.new()
  var collision_shape = _build_collision_shape()

  body.add_child(collision_shape)
  body.collision_layer = _get_bits_combined(collision_layer)
  body.collision_mask = _get_bits_combined(collision_mask)

  return body
  
func _build_collision_shape() -> CollisionPolygon2D:
  var vectorPack = PackedVector2Array(
    [Vector2(0, 0),
     Vector2(width/2.0, length),
     Vector2(-width/2.0, length)]
    )
  var collision_shape = CollisionPolygon2D.new()
  collision_shape.set_polygon(vectorPack)
  return collision_shape


func _get_bits_combined(list: Array[int]) -> int:
  var bits := 0
  for entry in list:
    bits += int(pow(entry, 2))

  return bits
  
func onDirectionChange() -> void:
  _body.set_global_rotation_degrees(_direction_to_degrees(actor.direction))
   
func _direction_to_degrees(v: Vector2) -> int:
  match v:
    Vector2(0, -1):
      return 180
    Vector2(1, 0):
      return 270
    Vector2(-1, 0):
      return 90
    _:
      if v.x > 0 and v.y < 0:
        return 225
      elif v.x > 0 and v.y > 0:
        return 315
      elif v.x < 0 and v.y > 0:
        return 45
      elif v.x < 0 and v.y < 0:
        return 135

      return 0

