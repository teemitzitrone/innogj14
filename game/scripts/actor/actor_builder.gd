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
const ActorLightConeComponent = preload("res://scripts/actor/components/actor_light_cone_colider.gd")

const WulfBuilder = preload("res://scripts/actor/wulf/wulf_builder.gd")
const KittyLightComponent = preload("res://scripts/actor/components/kitty_light_component.gd")

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
  
  var physics_light_cone_component = ActorLightConeComponent.new()
  physics_light_cone_component.length = 320
  physics_light_cone_component.width = 160
  physics_light_cone_component.collision_layer.append(2)
  physics_light_cone_component.collision_mask.append(2)
  actor.add_physics_component(physics_light_cone_component)

  var update_spritesheet_component = ActorUpdateSpritesheetComponent.new()
  actor.add_graphics_component(update_spritesheet_component)

  var spritesheet_component = _create_character_animation_sprite(
    "res://assets/gfx/pc/kitty.png",
    {}
  )
  spritesheet_component.show_on_top = true

  actor.add_graphics_component(spritesheet_component)

  var light_comp = KittyLightComponent.new()
  actor.add_graphics_component(light_comp)

  return actor

static func create_wolf() -> Actor:
  return WulfBuilder.create_wolf()




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
