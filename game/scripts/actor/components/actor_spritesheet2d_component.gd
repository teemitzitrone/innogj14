extends "res://scripts/actor/actor_component.gd"
## ActorSpritesheet2DComponent
##
## This component expects a texture with equaled sized frames


## This order of blend positions has to be the same order that you use in
## animation_nodes.
const BLEND_POSITIONS := [
  Vector2(0.0, 1.0), # down
  Vector2(-1.0, 0.0), # left
  Vector2(1.0, 0.0), # right
  Vector2(0.0, -1.0), # up
  ]
const ANIMATION_LIB_NAME := "move"


var texture: String

## number of frames, not size of a frame
var frame_size := Vector2i.ZERO
var frame_time_distance := 0.0
var region_rect := Rect2(Vector2.ZERO, Vector2.ZERO)

var shader = null
var shader_parameters := {}

## {"animatione_name":[1,0,1,2]} - numbers are the frame indices
var animations := {}

## {"node_name":["anim_name_down", "anim_name_left", "anim_name_right", "anim_name_up"]}
## first node is start node
var animation_nodes := {}

## {"start_node_name" : ["target_node_name1", "target_node_name2"]}
var animation_transitions := {}

## default animation name
var animation_default := ""


var _sprite: Sprite2D = null
var _animation_player: AnimationPlayer = null
var _animation_tree: AnimationTree = null
var _state_machine: AnimationNodeStateMachinePlayback = null


func ready() -> void:
  _init_sprite()
  _init_animation_player()
  _init_animation_tree()

  actor.component_message_send.connect(_on_actor_component_message_send)


func process(_delta: float) -> void:
  var current_animation_node = _state_machine.get_current_node()
  _animation_tree.set("parameters/%s/blend_position" % current_animation_node, actor.direction)


func _on_actor_component_message_send(message_type, info) -> void:
  if message_type == "animation_state":
    var current_animation_node = _state_machine.get_current_node()

    if current_animation_node != info:
      _state_machine.travel(info)


func _init_sprite() -> void:
  assert(!texture.is_empty())
  assert(frame_size.x > 0)
  assert(frame_size.y > 0)
  assert(region_rect.size.x > 0)
  assert(region_rect.size.y > 0)

  _sprite = Sprite2D.new()
  _sprite.texture = load(texture)
  _sprite.region_enabled = true
  _sprite.region_rect = region_rect
  _sprite.hframes = frame_size.x
  _sprite.vframes = frame_size.y
  _sprite.position.y = -58
  _sprite.centered = false

  _sprite.y_sort_enabled = true

  if shader:
    _sprite.material = shader
    for p in shader_parameters:
      _sprite.material.set_shader_parameter(p, shader_parameters[p])

  actor.add_child(_sprite)


func _init_animation_player() -> void:
  assert(_sprite)
  assert(frame_time_distance > 0)

  _animation_player = AnimationPlayer.new()
  var animation_library = AnimationLibrary.new()

  for a in animations:
    var anim = _build_animation(a, animations[a])
    animation_library.add_animation(a, anim)

  _animation_player.add_animation_library(ANIMATION_LIB_NAME, animation_library)

  actor.add_child(_animation_player)


func _init_animation_tree() -> void:
  assert(_animation_player)

  _animation_tree = AnimationTree.new()
  _animation_tree.anim_player = _animation_player.get_path()

  var state_machine = _build_animation_state_machine()

  _animation_tree.tree_root = state_machine
  _animation_tree.active = true

  actor.add_child(_animation_tree)

  _state_machine = _animation_tree.get("parameters/playback")
  _state_machine.start(animation_default)


func _build_animation(_name : String, frames : Array) -> Animation:
  var anim := Animation.new()
  var track_index := anim.add_track(Animation.TYPE_VALUE)

  var sprite_node_path = str(_sprite.get_path()) + ":frame"

  anim.track_set_path(track_index, NodePath(sprite_node_path))
  anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
  anim.loop_mode = Animation.LOOP_LINEAR
  anim.length = frames.size() * frame_time_distance

  var time = 0.0
  for frame in frames:
    anim.track_insert_key(track_index, time, frame)
    time += frame_time_distance

  return anim


func _build_animation_state_machine() -> AnimationNodeStateMachine:
  var state_machine = AnimationNodeStateMachine.new()

  for n in animation_nodes:
    var blend_node = _build_animation_node(n, animation_nodes[n])
    state_machine.add_node(n, blend_node)

  for from in animation_transitions:
    for to in animation_transitions[from]:
      if from == to:
        continue
      var transition = AnimationNodeStateMachineTransition.new()
      state_machine.add_transition(from, to, transition)

  return state_machine


func _build_animation_node(_name : String, blend_nodes : Array) -> AnimationNodeBlendSpace2D:
  assert(blend_nodes.size() == BLEND_POSITIONS.size())

  var node = AnimationNodeBlendSpace2D.new()
  node.blend_mode = AnimationNodeBlendSpace2D.BLEND_MODE_DISCRETE

  for i in range(blend_nodes.size()):
    var anim = AnimationNodeAnimation.new()
    anim.set_animation(ANIMATION_LIB_NAME + "/" + blend_nodes[i])

    node.add_blend_point(anim, BLEND_POSITIONS[i])

  return node
