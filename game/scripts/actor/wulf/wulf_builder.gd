const Actor = preload("res://scripts/actor/actor.gd")
const ActorPhysicsMoveAndCollideComponent = preload("res://scripts/actor/components/actor_physics_moveandcollide_component.gd")
const ActorUpdateSpritesheetComponent = preload("res://scripts/actor/components/actor_update_spritesheet_component.gd")
const ActorSpritesheet2DComponent = preload("res://scripts/actor/components/actor_spritesheet2d_component.gd")

static func getWolfSrite(sprite: int, animation: int, direction: int) -> int:
  var rowLength = 3
  var animationCount = 4
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
    "attack_down": [getWolfSrite(1, 1, 3), getWolfSrite(0, 1, 3), getWolfSrite(1, 1, 3), getWolfSrite(2, 2, 3)],
    "attack_up": [getWolfSrite(1, 1, 2), getWolfSrite(0, 1, 2), getWolfSrite(1, 1, 2), getWolfSrite(2, 2, 2)],
    "attack_right": [getWolfSrite(1, 1, 1), getWolfSrite(0, 1, 1), getWolfSrite(1, 1, 1), getWolfSrite(2, 2, 1)],
    "attack_left": [getWolfSrite(1, 1, 0), getWolfSrite(0, 1, 0), getWolfSrite(1, 1, 0), getWolfSrite(2, 2, 0)],
    "bunny_down": [getWolfSrite(1, 3, 3), getWolfSrite(0, 3, 3), getWolfSrite(1, 3, 3), getWolfSrite(2, 3, 3)],
    "bunny_up": [getWolfSrite(1, 3, 2), getWolfSrite(0, 3, 2), getWolfSrite(1, 3, 2), getWolfSrite(2, 3, 2)],
    "bunny_right": [getWolfSrite(1, 3, 1), getWolfSrite(0, 3, 1), getWolfSrite(1, 3, 1), getWolfSrite(2, 3, 1)],
    "bunny_left": [getWolfSrite(1, 3, 0), getWolfSrite(0, 3, 0), getWolfSrite(1, 3, 0), getWolfSrite(2, 3, 0)]
  }
  anim_sprite.animation_nodes = {
    "idle": ["idle_down", "idle_left", "idle_right", "idle_up"],
    "run": ["run_down", "run_left", "run_right", "run_up"],
    "run_dark": ["run_dark_down", "run_dark_left", "run_dark_right", "run_dark_up"],
    "attack": ["attack_down", "attack_up", "attack_right", "attack_left"],
    "bunny": ["bunny_down", "bunny_up", "bunny_right", "bunny_left"]
  }
  anim_sprite.animation_transitions = {"idle": ["run", "run_dark", "attack", "bunny"], "run": ["idle", "run_dark", "attack", "bunny"], "run_dark": ["idle", "run", "bunny"], "attack": ["idle", "run"], "bunny": ["idle", "run", "attack", "run_dark"]}
  anim_sprite.animation_default = "run"
  actor.add_graphics_component(anim_sprite)

  return actor