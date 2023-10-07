extends "res://scripts/actor/actor_component.gd"


const LightScript = preload("res://scenes/objects/light/light.gd")
const Light = preload("res://scenes/objects/light/light.tscn")


var light = null

var charge: float = 1.0:
  set(value):
    charge = value
    if light != null:
      light.get_node("LightArea").material.set_shader_parameter("charge", charge)

var discharge_speed: float = 0.05


func ready() -> void:
  light = Light.instantiate()
  actor.add_child(light)

  actor.direction_changed.connect(_on_actor_direction_changed)
  actor.velocity_changed.connect(_on_actor_direction_changed)
  G.crystal_broken.connect(_on_broke_crystal)


func init() -> void:
  pass


func input(_event: InputEvent) -> void:
  pass


func process(_delta: float) -> void:
  charge -= _delta * discharge_speed


func physics_process(_delta: float) -> void:
  pass


func _on_actor_direction_changed():
  if light == null:
    return

  if actor.velocity == Vector2.ZERO:
    light.current_direction = LightScript.Direction.DOWN
  else:
    light.set_direction_vector(actor.direction)


func _on_broke_crystal() -> void:
  charge = 1.0
