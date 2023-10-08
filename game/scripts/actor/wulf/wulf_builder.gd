extends RefCounted

const Actor = preload("res://scripts/actor/actor.gd")
const ActorPhysicsMoveAndCollideComponent = preload("res://scripts/actor/components/actor_physics_moveandcollide_component.gd")
const ActorUpdateSpritesheetComponent = preload("res://scripts/actor/components/wolf_sprite_update_component.gd")
const ActorSpritesheet2DComponent = preload("res://scripts/actor/components/actor_spritesheet2d_component.gd")
const WolfAiComponent = preload("res://scripts/actor/components/wolf_ai_component.gd")

static func getImageIdex(sprite: int, animation: int, direction: int) -> int:
  var rowLength = 3
  var animationCount = 4
  return (direction * rowLength * animationCount) + (animation * rowLength) + sprite

static func getPingPong(animation: int, direction: int) -> Array:
  return [getImageIdex(1, animation, direction), getImageIdex(0, animation, direction), getImageIdex(1, animation, direction), getImageIdex(2, animation, direction)]

static func create_wolf() -> Actor:
  var actor = Actor.new()
  actor.add_to_group("wolf")
  actor.speed = 30.0

  var input_component = WolfAiComponent.new()
  actor.add_logic_component(input_component)

  var physics_component = ActorPhysicsMoveAndCollideComponent.new()
  physics_component.feet_collider = Rect2(0, 2, 8, 4)
  physics_component.collision_layer.append(1)
  physics_component.collision_layer.append(2)
  physics_component.collision_mask.append(1)
  physics_component.collision_mask.append(2)
  physics_component.is_wolf = true # hack hack gamejam
  actor.add_physics_component(physics_component)

  var update_spritesheet_component = ActorUpdateSpritesheetComponent.new()
  actor.add_graphics_component(update_spritesheet_component)

  var anim_sprite = ActorSpritesheet2DComponent.new()
  anim_sprite.texture = "res://assets/gfx/npc/Wulf.png"
  anim_sprite.frame_size = Vector2i(3, 16)
  anim_sprite.frame_time_distance = 0.2
  anim_sprite.region_rect = Rect2(Vector2.ZERO, Vector2(48, 256))
  anim_sprite.animations = {
    "idle_down": [getImageIdex(1, 0, 3)],
    "idle_up": [getImageIdex(1, 0, 2)],
    "idle_right": [getImageIdex(1, 0, 1)],
    "idle_left": [getImageIdex(1, 0, 0)],
    "run_down": getPingPong(0, 3),
    "run_up": getPingPong(0, 2),
    "run_right": getPingPong(0, 1),
    "run_left": getPingPong(0, 0),
    "run_dark_down": getPingPong(2, 3),
    "run_dark_up": getPingPong(2, 2),
    "run_dark_right": getPingPong(2, 1),
    "run_dark_left": getPingPong(2, 0),
    "attack_down": getPingPong(1, 3),
    "attack_up": getPingPong(1, 2),
    "attack_right": getPingPong(1, 1),
    "attack_left": getPingPong(1, 0),
    "bunny_down": getPingPong(3, 3),
    "bunny_up": getPingPong(3, 2),
    "bunny_right": getPingPong(3, 1),
    "bunny_left": getPingPong(3, 0)
  }
  anim_sprite.animation_nodes = {
    "idle": ["idle_down", "idle_left", "idle_right", "idle_up"],
    "run": ["run_down", "run_left", "run_right", "run_up"],
    "run_dark": ["run_dark_down", "run_dark_left", "run_dark_right", "run_dark_up"],
    "attack": ["attack_down", "attack_left", "attack_right", "attack_up"],
    "bunny": ["bunny_down", "bunny_left", "bunny_right", "bunny_up"]
  }
  anim_sprite.animation_transitions = {"idle": ["run", "run_dark", "attack", "bunny"], "run": ["idle", "run_dark", "attack", "bunny"], "run_dark": ["idle", "run", "bunny"], "attack": ["idle", "run"], "bunny": ["idle", "run", "attack", "run_dark"]}
  anim_sprite.animation_default = "run"
  actor.add_graphics_component(anim_sprite)

  return actor
