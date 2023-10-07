extends RefCounted
## ActorBuilder


# signals
# enums
# inner classes
# constants
const Actor = preload("res://scripts/actor/actor.gd")

const ActorComponent = preload("res://scripts/actor/actor_component.gd")
const ActorInputMoveComponent = preload("res://scripts/actor/components/actor_input_move_component.gd")
const ActorPhysicsMoveAndCollideComponent = preload("res://scripts/actor/components/actor_physics_moveandcollide_component.gd")
const ActorSpritesheet2DComponent = preload("res://scripts/actor/components/actor_spritesheet2d_component.gd")
const ActorUpdateSpritesheetComponent = preload("res://scripts/actor/components/actor_update_spritesheet_component.gd")


static func create_kitty() -> Actor:
  var actor = Actor.new()
  actor.add_to_group("kitty")

  var input_component = ActorInputMoveComponent.new()
  actor.add_logic_component(input_component)

  var physics_component = ActorPhysicsMoveAndCollideComponent.new()
  physics_component.feet_collider = Rect2(0, 4, 16, 4)
  physics_component.collision_layer.append(1)
  physics_component.collision_mask.append(1)
  actor.add_physics_component(physics_component)

  var update_spritesheet_component = ActorUpdateSpritesheetComponent.new()
  actor.add_graphics_component(update_spritesheet_component)

  var spritesheet_component = _create_character_animation_sprite(
    "res://assets/gfx/pc/kitty.png",
    {}
  )

  actor.add_graphics_component(spritesheet_component)

  return actor

static func getWolfSrite(sprite: int, animation: int, direction: int) -> int:
  var rowLength = 3
  var animationCount = 3
  return (direction * rowLength * animationCount) + (animation * rowLength) + sprite

static func create_wolf() -> Actor:
  var actor = Actor.new()
  actor.add_to_group("wolf")

  var physics_component = ActorPhysicsMoveAndCollideComponent.new()
  physics_component.feet_collider = Rect2(16, 2, 32, 4)
  physics_component.collision_layer.append(1)
  physics_component.collision_mask.append(1)
  actor.add_physics_component(physics_component)

  var update_spritesheet_component = ActorUpdateSpritesheetComponent.new()
  actor.add_graphics_component(update_spritesheet_component)

  var anim_sprite = ActorSpritesheet2DComponent.new()
  anim_sprite.texture = "res://assets/gfx/npc/Wulf.png"
  anim_sprite.frame_size = Vector2i(3, 8)
  anim_sprite.frame_time_distance = 0.2
  anim_sprite.region_rect = Rect2(Vector2.ZERO, Vector2(48, 128))
  anim_sprite.animations = {
    "idle_down": [getWolfSrite(1, 0, 3)],
    "idle_up": [getWolfSrite(1, 0, 2)],
    "idle_right": [getWolfSrite(1, 0, 1)],
    "idle_left": [getWolfSrite(1, 0, 0)],
    "run_down": [getWolfSrite(1, 0, 3), getWolfSrite(0, 0, 3), getWolfSrite(1, 0, 3), getWolfSrite(2, 0, 3)],
    "run_up": [getWolfSrite(1, 0, 2), getWolfSrite(0, 0, 2), getWolfSrite(1, 0, 2), getWolfSrite(2, 0, 2)],
    "run_right": [getWolfSrite(1, 0, 1), getWolfSrite(0, 0, 1), getWolfSrite(1, 0, 1), getWolfSrite(2, 0, 1)],
    "run_left": [getWolfSrite(1, 0, 0), getWolfSrite(0, 0, 0), getWolfSrite(1, 0, 0), getWolfSrite(2, 0, 0)],
    "run_dark_down": [getWolfSrite(1, 2, 3), getWolfSrite(0, 2, 3), getWolfSrite(1, 2, 3), getWolfSrite(2, 2, 3)],
    "run_dark_up": [getWolfSrite(1, 2, 2), getWolfSrite(0, 2, 2), getWolfSrite(1, 2, 2), getWolfSrite(2, 2, 2)],
    "run_dark_right": [getWolfSrite(1, 2, 1), getWolfSrite(0, 2, 1), getWolfSrite(1, 2, 1), getWolfSrite(2, 2, 1)],
    "run_dark_left": [getWolfSrite(1, 2, 0), getWolfSrite(0, 2, 0), getWolfSrite(1, 2, 0), getWolfSrite(2, 2, 0)],
  }
  anim_sprite.animation_nodes = {
    "idle": ["idle_down", "idle_left", "idle_right", "idle_up"],
    "run": ["run_down", "run_left", "run_right", "run_up"],
    "run_dark": ["run_dark_down", "run_dark_left", "run_dark_right", "run_dark_up"],
  }
  anim_sprite.animation_transitions = {"idle": ["run", "run_dark"], "run": ["idle", "run_dark"], "run_dark": ["idle", "run"]}
  anim_sprite.animation_default = "run"
  actor.add_graphics_component(anim_sprite)

  return actor




static func _create_character_animation_sprite(tex: String, replacement_colors := {}) -> ActorSpritesheet2DComponent:
  var anim_sprite = ActorSpritesheet2DComponent.new()
  anim_sprite.texture = tex
  anim_sprite.frame_size = Vector2i(3, 5)
  anim_sprite.frame_time_distance = 0.2
  anim_sprite.region_rect = Rect2(Vector2.ZERO, Vector2(48, 80))
  anim_sprite.animations = {
    "idle_down": [13, 12, 14, 12],
    "idle_up": [13, 12, 14, 12],
    "idle_right": [13, 12, 14, 12],
    "idle_left": [13, 12, 14, 12],
    "run_down": [1, 0, 1, 2],
    "run_up": [4, 3, 4, 5],
    "run_right": [10, 9, 10, 11],
    "run_left": [7, 6, 7, 8],
  }
  anim_sprite.animation_nodes = {
    "idle": ["idle_down", "idle_left", "idle_right", "idle_up"],
    "run": ["run_down", "run_left", "run_right", "run_up"],
  }
  anim_sprite.animation_transitions = {"idle": ["run"], "run": ["idle"]}
  anim_sprite.animation_default = "run"
  anim_sprite.shader = ShaderMaterial.new()
  anim_sprite.shader.shader = load("res://assets/shader/actor_color.gdshader")
  anim_sprite.shader_parameters = {
    "original_color_0": Color8(50, 50, 50),
    "original_color_1": Color8(100, 100, 100),
    "original_color_2": Color8(150, 150, 150),
    "original_color_3": Color8(200, 200, 200),
    "original_color_4": Color8(255, 255, 255),
    "original_color_5": Color8(0, 255, 234),
  }
  for c in replacement_colors:
    anim_sprite.shader_parameters[c] = replacement_colors[c]

  return anim_sprite
