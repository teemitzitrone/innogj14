extends Node2D
## Actor


signal component_message_send(message_type, info)
signal direction_changed()
signal velocity_changed()


const ActorComponent = preload("res://scripts/actor/actor_component.gd")


var velocity := Vector2.ZERO:
  get:
    return velocity
  set(value):
    velocity = value
    emit_signal("velocity_changed")

var speed := 95.0:
  get:
    return speed
  set(value):
    speed = value

var direction := Vector2.ZERO:
  get:
    return direction
  set(value):
    direction = value
    emit_signal("direction_changed")


## input/AI/...
var _logic_components: Array[ActorComponent]
## handling velocity, speed, direction
var _physics_components: Array[ActorComponent]
## sprites, animations
var _graphics_components: Array[ActorComponent]


func _init() -> void:
  pass


func _ready() -> void:
  for c in _logic_components:
    c.ready()
  for c in _physics_components:
    c.ready()
  for c in _graphics_components:
    c.ready()


#func _draw() -> void:
#  if not OS.is_debug_build():
#    return
#
#  for c in get_children():
#    if not c.has_method("get_sprite"):
#      continue
#
#    var s = c.get_sprite()
#    draw_circle(s.position, 10.0, Color)


func _unhandled_input(event: InputEvent) -> void:
  for c in _logic_components:
    c.input(event)
  for c in _physics_components:
    c.input(event)
  for c in _graphics_components:
    c.input(event)


func _process(delta: float) -> void:
  for c in _logic_components:
    c.process(delta)
  for c in _physics_components:
    c.process(delta)
  for c in _graphics_components:
    c.process(delta)


func _physics_process(delta: float) -> void:
  for c in _logic_components:
    c.physics_process(delta)
  for c in _physics_components:
    c.physics_process(delta)
  for c in _graphics_components:
    c.physics_process(delta)


func add_logic_component(component: ActorComponent) -> void:
  _logic_components.append(component)
  _init_component(component)


func add_physics_component(component: ActorComponent) -> void:
  _physics_components.append(component)
  _init_component(component)


func add_graphics_component(component: ActorComponent) -> void:
  _graphics_components.append(component)
  _init_component(component)


func _init_component(component: ActorComponent) -> void:
  component.actor = self
  component.init()
