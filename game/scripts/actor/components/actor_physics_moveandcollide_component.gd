extends "res://scripts/actor/actor_component.gd"
## ActorPhysicsMoveAndCollideComponent


# signals
# enums
# inner classes
# constants
# exported variables
# public variables
var feet_collider := Rect2()

## list of layers the body shall be in
var collision_layer : Array[int] = []

## list of masks the body shall interact with
var collision_mask : Array[int] = []

var groups_data: Array = []

# is dirty, but this is a gamejam
var is_wolf := false


# private variables (precede with "_")
var _body : CharacterBody2D = null

# onready variables

# optional public static methods
#static func get_ctor_params() -> Array:
#  return []

# optional built-in virtual _init method
#func _init() -> void:
#  pass

# built-in virtual _ready method
func ready() -> void:
  _body = _build_kinematic_body()
  actor.add_child(_body)

# remaining built-in virtual methods
func physics_process(_delta: float) -> void:
  _body.velocity = actor.velocity
  _body.move_and_slide()

  if is_wolf:
    for i in _body.get_slide_collision_count():
      var collision = _body.get_slide_collision(i)
#      print_debug(collision.get_collider().name)
      if collision.get_collider().name == "LightCone":
        actor.component_message_send.emit("collision", "wolf:lightcone")
      elif collision.get_collider().is_in_group("kitty"):
        G.kill_kitty.emit()


  if _body.position != Vector2.ZERO:
    actor.position += _body.position
    _body.position = Vector2.ZERO
# getters & setters
# public methods
# private methods
func _build_kinematic_body() -> CharacterBody2D:
  var body = CharacterBody2D.new()
  for g in groups_data:
    body.add_to_group(g)
  var collision_shape = _build_collision_shape()

  body.add_child(collision_shape)
  body.collision_layer = _get_bits_combined(collision_layer)
  body.collision_mask = _get_bits_combined(collision_mask)

  return body


func _build_collision_shape() -> CollisionShape2D:
  var collision_shape = CollisionShape2D.new()
#  var rect_shape = RectangleShape2D.new()
  var shape = CapsuleShape2D.new()

  shape.height = feet_collider.size.x
  shape.radius = feet_collider.size.y
#  shape.transform.rotation = 90
#  shape.rotation = 90

  collision_shape.shape = shape
  collision_shape.position = feet_collider.position
  collision_shape.rotation_degrees = 90

  return collision_shape


func _get_bits_combined(list: Array[int]) -> int:
  var bits := 0
  for entry in list:
    bits += int(pow(entry, 2))

  return bits
