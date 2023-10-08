extends "res://scripts/actor/actor_component.gd"

const DISTANCE_REQUIREMENT = 70.0

var bunny_active := false


func ready():
  actor.component_message_send.connect(on_message)


func process(_delta: float) -> void:
  var centerPoint = G.get_viewport().get_camera_2d().get_screen_center_position()

  if bunny_active:
    return

  if actor.velocity == Vector2.ZERO:
      actor.emit_signal("component_message_send", "animation_state", "run_dark")
      actor.emit_signal("component_message_send", "show_on_top", true)
  else:
    if actor.global_position.distance_to(centerPoint) < DISTANCE_REQUIREMENT:
      actor.emit_signal("component_message_send", "animation_state", "run")
      actor.emit_signal("component_message_send", "show_on_top", false)
    else:
      actor.emit_signal("component_message_send", "animation_state", "run_dark")
      actor.emit_signal("component_message_send", "show_on_top", true)


func on_message(type, info):
  if type == "ai_state_changed":
    if info == 1:
      actor.component_message_send.emit("animation_state", "bunny")
      bunny_active = true
    else:
      actor.component_message_send.emit("animation_state", "run_dark")
      bunny_active = false
