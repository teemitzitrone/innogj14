@tool
extends Node2D


enum Direction {
  UP,
  UP_RIGHT,
  RIGHT,
  DOWN_RIGHT,
  DOWN,
  DOWN_LEFT,
  LEFT,
  UP_LEFT,
}

class LightAssetConfig:
  extends RefCounted

  var region_pos: Vector2
  var flip_horizontal: bool
  var flip_vertical: bool

  func _init(rpos: Vector2, fliph: bool, flipv: bool):
    region_pos = rpos
    flip_horizontal = fliph
    flip_vertical = flipv


var LIGHT_ASSET_CONFIG_MAPPING = {
  Direction.UP: LightAssetConfig.new(Vector2.ZERO, false, true),
  Direction.UP_RIGHT: LightAssetConfig.new(Vector2(0, 360), false, false),
  Direction.RIGHT: LightAssetConfig.new(Vector2(0, 180), false, false),
  Direction.DOWN_RIGHT: LightAssetConfig.new(Vector2(0, 360), false, true),
  Direction.DOWN: LightAssetConfig.new(Vector2.ZERO, false, false),
  Direction.DOWN_LEFT: LightAssetConfig.new(Vector2(0, 360), true, true),
  Direction.LEFT: LightAssetConfig.new(Vector2(0, 180), true, false),
  Direction.UP_LEFT: LightAssetConfig.new(Vector2(0,360), true, false),
}

@export var current_direction: Direction:
  get:
    return current_direction
  set(value):
    current_direction = value
    _update_sprite()


func set_direction_vector(v: Vector2) -> void:
  current_direction = _translate_vector_to_direction(v)


func _translate_vector_to_direction(v: Vector2) -> Direction:
  match v:
    Vector2(0, -1):
      return Direction.UP
    Vector2(1, 0):
      return Direction.RIGHT
    Vector2(-1, 0):
      return Direction.LEFT
    _:
      if v.x > 0 and v.y < 0:
        return Direction.UP_RIGHT
      elif v.x > 0 and v.y > 0:
        return Direction.DOWN_RIGHT
      elif v.x < 0 and v.y > 0:
        return Direction.DOWN_LEFT
      elif v.x < 0 and v.y < 0:
        return Direction.UP_LEFT

      return Direction.DOWN


func _ready():
  _update_sprite()


func _update_sprite() -> void:
  var config = LIGHT_ASSET_CONFIG_MAPPING[current_direction]

  $LightArea.region_rect.position = config.region_pos
  $LightArea.flip_h = config.flip_horizontal
  $LightArea.flip_v = config.flip_vertical

